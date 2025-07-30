import psycopg2
from datetime import datetime
from fake import Farker
fake = Farker("pt_BR")

def entrada_boobelana(prompt):
    while True:
        resposta = input(prompt).lower()
        if resposta in ['s','n']:
            return resposta == 's'
        print("Error digite apenas 'n' ou 's'.")

def conector_banco():
    return psycopg2.connect(
        host="localhost",
        database="peso",
        user="vitor",
        password="133122"
    )

def inserir_dados():
    print("\nFAZER NOVO REGISTRO")
    print("-" * 50)

    try:
        conn = conector_banco()
        cursor = conn.cursor()

        nome = input('Nome: ')
        sobrenome = input("Sobrenome: ")
        nasc_input = input("Data de nascimento (YYYY-MM-DD): ")
        nasc = datetime.strptime(nasc_input, "%Y-%m-%d").date()
        sexo = input("Sexo (M/F): ").upper()
        peso = float(input("Peso (kg): "))
        altura = float(input("Altura (m): "))
        nacionalidade = input("Onde você nasceu: ") or "Brasil"

        if sexo not in ["M", "F"]:
            raise ValueError("Sexo deve ser M ou F")
        if peso <= 20 or altura <= 0:
            raise ValueError("Peso e altura devem ser positivos")

        sql = """
        INSERT INTO paciente 
        (nome, sobrenome, nasc, sexo, peso, altura, nacionalidade)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        valores = (nome, sobrenome, nasc, sexo, peso, altura, nacionalidade)

        cursor.execute(sql, valores)
        conn.commit()
        print("Registro inserido com sucesso")

    except ValueError as ve:
        print(f"\nErro na validação: {ve}")
    except psycopg2.Error as err:
        print(f"\nErro no banco de dados: {err}")
        if 'conn' in locals():
            conn.rollback()
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()

def insercao_auto():
    print("\nINSERÇÃO AUTOMÁTICA")
    print("-" * 50)

    try:
        conn = conector_banco()
        cursor = conn.cursor()

        quant = int(input("Quantos registros você quer inserir automaticamente? "))

        for _ in range(quant):
            nome = fake.first_name()
            sobrenome = fake.last_name()
            nasc = fake.date_of_birth(minimum_age=18, maximum_age=90)
            sexo = fake.random_element(elements=("M", "F"))
            peso = round(fake.random_number(digits=2) + 40, 2)
            altura = round(fake.random_number(digits=1) / 10 + 1.5, 2)
            nacionalidade = fake.country()

            sql = """
            INSERT INTO paciente 
            (nome, sobrenome, nasc, sexo, peso, altura, nacionalidade)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
            valores = (nome, sobrenome, nasc, sexo, peso, altura, nacionalidade)

            cursor.execute(sql, valores)

        conn.commit()
        print(f"{quant} registros inseridos com sucesso.")

    except Exception as e:
        print(f"\nErro: {e}")
        if 'conn' in locals():
            conn.rollback()
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()


if __name__ == "__main__":
    while True:
        modo = input("\n[1] Inserir manualmente\n[2] Inserção automática\nEscolha: ")
        if modo == "1":
            inserir_dados()
        elif modo == "2":
            insercao_auto()
        else:
            print("Opcao invalida")
        
        continuar = input("\n pretende continuar? (S/N)").upper
        if continuar != "S":
            break
