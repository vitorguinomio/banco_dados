import psycopg2
from psycopg2 import Error
import os
from datetime import datetime

# Configuração da conexão com o banco de dados
DB_CONFIG = {
    'dbname': os.getenv('POSTGRES_DB', 'reservadb'),
    'user': os.getenv('POSTGRES_USER', 'vitor'),
    'password': os.getenv('POSTGRES_PASSWORD', '133122'),
    'host': 'localhost'
}

def obter_entrada_booleana(prompt):
    while True:
        resposta = input(prompt).lower()
        if resposta in ['s', 'n']:
            return resposta == 's'
        print("Erro: Digite apenas 's' ou 'n'.")

def conectar_banco():
    """Conecta ao banco de dados PostgreSQL e retorna a conexão e o cursor."""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        return conn, cur
    except Error as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        return None, None

def inserir_reserva():
    """Função para fazer uma reserva, chamando a função SQL inserir_reserva."""
    try:
        conn, cur = conectar_banco()
        if not conn or not cur:
            return

        print("\n=== Fazer Reserva ===")
        try:
            matriculauser = int(input("Digite a matrícula do usuário: "))
            codturma = input("Digite o código da turma (ex.: ADM02N1): ").strip()
            datainicial = input("Digite a data inicial (YYYY-MM-DD, ex.: 2025-08-11): ").strip()
            datafinal = input("Digite a data final (YYYY-MM-DD, ex.: 2025-11-30): ").strip()
            nomebloco = input("Digite a letra do bloco (ex.: A): ").strip()
            numerosala = int(input("Digite o número da sala (ex.: 101): "))
            turno = input("Digite o turno (Manhã, Tarde, Noite): ").strip()
            responsavel = input("Digite o nome do responsável: ").strip()

            # Validações básicas no Python
            if not codturma:
                print("Erro: Código da turma não pode ser vazio.")
                return
            if turno not in ['Manhã', 'Tarde', 'Noite']:
                print("Erro: Turno deve ser Manhã, Tarde ou Noite.")
                return
            if not responsavel:
                print("Erro: Responsável não pode ser vazio.")
                return
           
            try:
                datetime.strptime(datainicial, '%Y-%m-%d')
                datetime.strptime(datafinal, '%Y-%m-%d')
            except ValueError:
                print("Erro: Formato de data inválido. Use YYYY-MM-DD.")
                return

            periodos = []
            for p in ['primeiro', 'segundo', 'terceiro', 'quarto', 'integral']:
                resposta = obter_entrada_booleana(f"Reservar no período {p}? (s/n): ")
                periodos.append(resposta)
            if len(periodos) != 5:
                print("Erro: Devem ser especificados exatamente 5 períodos.")
                return
            
            diasemana = []
            for d in ['segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo']:
                resposta = obter_entrada_booleana(f"Reservar na {d}? (s/n): ")
                diasemana.append(resposta)
            if len(diasemana) != 7:
                print("Erro: Devem ser especificados exatamente 7 dias da semana.")
                return

          
            cur.execute("""
                SELECT inserir_reserva02(
                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                )
            """, (
                matriculauser,
                codturma,
                datainicial,
                datafinal,
                numerosala,
                nomebloco,
                turno,
                responsavel,
                periodos,
                diasemana
            ))

            idreserva = cur.fetchone()[0]
            conn.commit()
            print(f"\nReserva criada com sucesso! ID da reserva: {idreserva}")

        except ValueError as ve:
            print(f"Erro de entrada: {ve}")
        except Error as e:
            print(f"Erro ao fazer reserva: {e}")
            conn.rollback()

    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

def cadastra_sala():
    """ Funcao para cadastro da sala"""
    try:
        conn, cur = conectar_banco()
        if not conn or not cur:
            return

        print("\n=== Cadastrar Sala ===")
        try:
            nomebloco = input("Digite a letra do bloco (ex.: A): ").strip()
            andar = input("Digite o andar (ex.: Térreo): ").strip()
            numerosala = int(input("Digite o número da sala (ex.: 101): "))
            capacidade = int(input("Digite a capacidade de alunos da sala (ex.: 55): "))
            tvtamanho = input("Digite o tamanho da TV (ex.: 55\", ou 0 se não houver): ").strip()
            datashow = obter_entrada_booleana("A sala tem datashow? (s/n): ")
            matriculauser = int(input("Digite a matrícula do usuário responsável: "))

            # Validações básicas
            if not nomebloco or len(nomebloco) != 1:
                print("Erro: Nome do bloco deve ser uma única letra.")
                return
            if not andar:
                print("Erro: Andar não pode ser vazio.")
                return
            if not tvtamanho:
                print("Erro: Tamanho da TV não pode ser vazio (use '0' se não houver).")
                return

            # Verifica se o usuário existe
            cur.execute("""
                SELECT 1 FROM usuario 
                WHERE matricula = %s AND statusdelete = FALSE
            """, (matriculauser,))
            if not cur.fetchone():
                print(f"Erro: Usuário com matrícula {matriculauser} não encontrado.")
                return

            # Verifica se o bloco existe
            cur.execute("""
                SELECT idbloco FROM bloco 
                WHERE nomebloco = %s AND statusdelete = FALSE
            """, (nomebloco,))
            bloco = cur.fetchone()

            if not bloco:
                print(f"Bloco {nomebloco} não encontrado. Criando novo bloco...")
                cur.execute("""
                    INSERT INTO bloco (nomebloco, matriculauser, ativo, dthinsert, statusdelete)
                    VALUES (%s, %s, TRUE, NOW(), FALSE)
                    RETURNING idbloco
                """, (nomebloco, matriculauser))
                idbloco = cur.fetchone()[0]
            else:
                idbloco = bloco[0]

            cur.execute("""
                SELECT idsala FROM sala
                WHERE nomebloco = %s AND numerosala = %s AND statusdelete = FALSE
            """, (nomebloco, numerosala))
            if cur.fetchone():
                print(f"Erro: Sala com bloco {nomebloco} e número {numerosala} já existe.")
                return

            # Insere a sala
            cur.execute("""
                INSERT INTO sala (idbloco, nomebloco, numerosala, capacidade, tvtamanho, datashow, matriculauser, dthinsert, statusdelete)
                VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), FALSE)
                RETURNING idsala
            """, (
                idbloco,
                nomebloco,
                numerosala,
                capacidade,
                tvtamanho,
                datashow,
                matriculauser
            ))

            idsala = cur.fetchone()[0]
            conn.commit()


        except ValueError as ve:
            print(f"Erro de entrada: {ve}")
        except Error as e:
            print(f"Erro ao cadastrar sala: {e}")
            conn.rollback()

    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

def ver_sala():
    """ Funcao para cadastro da sala"""
    try:
        conn, cur = conectar_banco()
        if not conn or not cur:
            return
        
        cur.execute("SELECT * FROM sala;")
        salas = cur.fetchall()
        
        if not salas:
            print("Nenhuma sala cadastrada.")
        else:
            print("\n=== Lista de Salas ===")
            for sala in salas:
                print(sala)

    except Error as e:
        print(f"Erro ao buscar salas: {e}")
    
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    print("1 - Fazer Reserva")
    print("2 - Cadastrar Sala")
    print("3 - Ver salas existentes")
    opcao = input("Escolha uma opção (1-3): ").strip()

    if opcao == '1':
        inserir_reserva()
    elif opcao == '2':
        cadastra_sala()
    elif opcao == '3':
        ver_sala()
    else:
        print("Nao existe essa opcao")
