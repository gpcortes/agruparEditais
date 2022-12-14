from caworker import Worker
from sqlalchemy import create_engine
import pandas as pd
from time import sleep
import mysql.connector
import envconfiguration as config
from urllib.parse import quote


def get_engine():
    string_connection = "mysql+pymysql://{user}:{password}@{host}:{port}/{database}".format(
        user=config.CAMUNDA_DOMAINS_USER,  # type: ignore
        password=quote(config.CAMUNDA_DOMAINS_PASS),  # type: ignore
        host=config.CAMUNDA_DOMAINS_HOST,  # type: ignore
        port=config.CAMUNDA_DOMAINS_PORT,  # type: ignore
        database=config.CAMUNDA_DOMAINS_DB  # type: ignore
    )
    return create_engine(string_connection)

    
def inserir_dados_bd_edital(ano,num_edital, escola_id):
    mydb = mysql.connector.connect(
        user=config.CAMUNDA_DOMAINS_USER,  # type: ignore
        password=config.CAMUNDA_DOMAINS_PASS,  # type: ignore
        host=config.CAMUNDA_DOMAINS_HOST,  # type: ignore
        port=config.CAMUNDA_DOMAINS_PORT,  # type: ignore
        database=config.CAMUNDA_DOMAINS_DB  # type: ignore
    )

    mycursor = mydb.cursor()
    sql = "INSERT INTO edital_ensino (num_edital,ano, escola_id) VALUES (%s, %s, %s)"
    val = (int(num_edital), int(ano), int(escola_id))
    mycursor.execute(sql, val)
    mydb.commit()
    num_edital = mycursor.lastrowid
    return num_edital


def inserir_dados_tpo(num_edital_id, turmas_do_edital):
    for i in turmas_do_edital:
        
        mydb = mysql.connector.connect(
            user=config.CAMUNDA_DOMAINS_USER,  # type: ignore
            password=config.CAMUNDA_DOMAINS_PASS,  # type: ignore
            host=config.CAMUNDA_DOMAINS_HOST,  # type: ignore
            port=config.CAMUNDA_DOMAINS_PORT,  # type: ignore
            database=config.CAMUNDA_DOMAINS_DB  # type: ignore
        )
        mycursor = mydb.cursor()
        sql = "UPDATE Turmas_planejado_orcado SET num_edital_id = {}  WHERE id = {}". format(str(num_edital_id), str(i))
        print(sql)
        mycursor.execute(sql)
        mydb.commit()
        num_edital = mycursor.lastrowid
        print(i)
        sleep(5)
    return print("Dados Inseridos com Sucesso!")


if __name__ == '__main__':
    worker = Worker()
    
    print('Worker started')
    while True:

        tasks = worker.fetch_tasks()

        for task in tasks:
            print("entrei dentro do worker")

            turmas_planejadas = pd.read_sql_query("SELECT tpo.*, esc.escola, um.municipio, md.modalidade, tc.tipo, cr.curso from Turmas_planejado_orcado tpo inner JOIN escolas esc ON esc.id = tpo.escola_id left JOIN udepi_municipio um ON um.escola_id = esc.id INNER JOIN modalidade md ON md.id = tpo.modalidade_id INNER JOIN tipo_curso tc ON tc.id = tpo.tipo_curso_id INNER JOIN cursos cr ON cr.id = tpo.curso_id where tpo.num_edital_id = 0", con=get_engine())

            ano_do_edital = turmas_planejadas.groupby(by=['ano', 'escola_id', 'tipo', 'modalidade']).groups         
            listachaves = list(ano_do_edital.keys())
            for chave in listachaves:
                numEdital = pd.read_sql_query("select max(num_edital),ano,escola_id,id  from edital_ensino group By ano,escola_id",  con=get_engine())
                indices = list(ano_do_edital.get(chave) # type: ignore
                               )
                turmas_do_edital = list(turmas_planejadas.iloc[indices]['id'])
                escolaId = chave[1] # type: ignore
                ano = chave[0] # type: ignore
                try:
                    num_edital = list(numEdital['max(num_edital)'][numEdital['escola_id'] == escolaId][numEdital['ano'] == ano])[0] + 1
                except:
                    num_edital = 1
                num_edital_id = inserir_dados_bd_edital(ano, num_edital, escolaId)
                inserir_dados_tpo(num_edital_id, turmas_do_edital)
                sleep(5)

            worker.complete_task(task_id=task.id_, variables={})
            print('Inser????o realizada com sucesso!')
        sleep(5)
