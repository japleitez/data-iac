import base64
import json
import logging
import uuid
from datetime import timedelta, datetime

# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG, settings
from airflow.configuration import conf
from airflow.models import Connection
# Operators; we need this to operate!
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.http.operators.http import SimpleHttpOperator

# These args will get passed on to each operator
# You can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'evangelos',
    'depends_on_past': False,
    'email': ['evangelos.sinapidis@arhs-cube.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}


def create_authorization_headers():
    client_id = conf.get('wihp', 'client_id')
    client_secret = conf.get('wihp', 'client_secret')
    user_pass = client_id + ":" + client_secret
    b64val = base64.b64encode(bytes(user_pass, "utf-8")).decode("ascii")

    headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Basic %s" % b64val
    }
    return headers


def create_authorization_form():
    client_id = conf.get('wihp', 'client_id')
    client_secret = conf.get('wihp', 'client_secret')
    oauth_scope = conf.get('wihp', 'oauth_scope')
    auth_form = "client_id=" + client_id + \
                "&client_secret=" + client_secret + \
                "&grant_type=client_credentials" + \
                "&scope=" + oauth_scope
    return auth_form


def acquisition_authorization_headers(access_token):
    bearer = "Bearer " + access_token
    return {
        "Content-Type": "application/json",
        "Authorization": bearer
    }


def create_conn(conn_id, conn_type, host, port, scheme):
    conn = Connection(
        conn_id=conn_id,
        conn_type=conn_type,
        schema=scheme,
        host=host,
        port=port
    )
    session = settings.Session()
    conn_name = session \
        .query(Connection) \
        .filter(Connection.conn_id == conn.conn_id) \
        .first()

    if str(conn_name) == str(conn_id):
        return logging.info(f"Connection {conn_id} already exists")

    session.add(conn)
    session.commit()
    logging.info(f'Connection {conn_id} is created')


def check(response):
    if response == 200:
        logging.info("Returning True")
        return True
    else:
        logging.info(f"Returning False {response}")
        return False


create_conn("data_acquisition_service", "http",
            conf.get('wihp', 'data_acquisition_service_host'),
            conf.get('wihp', 'data_acquisition_service_port'), 'http')

create_conn("oauth_service", "http", conf.get('wihp', 'oauth_host'), conf.get('wihp', 'oauth_port'), 'https')

with DAG(
        'my_workflow',
        default_args=default_args,
        description='This DAG will trigger an Acquisition and it will stop it 5 mins later',
        schedule_interval=None,
        start_date=datetime(1970, 1, 1),
        tags=['wihp-tutorial'],
) as dag:
    workflow_uuid = PythonOperator(
        task_id='workflow_uuid',
        python_callable=lambda: str(uuid.uuid4())
    )

    access_token = SimpleHttpOperator(
        task_id='access_token',
        http_conn_id='oauth_service',
        endpoint='oauth2/token',
        method='POST',
        data=create_authorization_form(),
        headers=create_authorization_headers(),
        response_check=lambda response: response.json()['access_token'],
        response_filter=lambda response: response.json()['access_token'],
        dag=dag,
        log_response=True,
    )

    submit_acquisition = SimpleHttpOperator(
        task_id='submit_acquisition',
        http_conn_id='data_acquisition_service',
        endpoint='api/acquisitions',
        method='POST',
        data=json.dumps({
            "name": "crawler1",
            "uuid": "{{ task_instance.xcom_pull('workflow_uuid') }}"
        }),
        headers=acquisition_authorization_headers("{{ task_instance.xcom_pull('access_token') }}"),
        response_check=lambda response: response.json()['id'],
        response_filter=lambda response: response.json()['id'],
        dag=dag,
        log_response=True,
    )

    do_some_work = BashOperator(
        task_id="delay_bash_task",
        dag=dag,
        bash_command="sleep 5m")

    stop_acquisition = SimpleHttpOperator(
        task_id='stop_acquisition',
        http_conn_id='data_acquisition_service',
        endpoint="api/acquisitions/{{ task_instance.xcom_pull('submit_acquisition') }}/action/STOP",
        method='POST',
        headers=acquisition_authorization_headers("{{ task_instance.xcom_pull('access_token') }}"),
        response_check=lambda response: True if check(response.status_code) is True else False,
        dag=dag,
        log_response=True,

    )

    workflow_uuid >> access_token >> submit_acquisition >> do_some_work >> stop_acquisition
