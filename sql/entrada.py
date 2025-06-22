import psycopg2
from datetime import datetime

conn = psycopg2.connect(
    host="localhost",
    database="pysql",
    user="Vitor",
    password="133122"
)

def inserir_dados():
    print("\n FAZER NOVO REGISTRO")
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

        sql = """INSERT INTO nome_da_tabela 
        (nome, sobrenome, nasc, sexo, peso, altura, nacionalidade)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        valores = (nome, sobrenome, nasc, sexo, peso, altura, nacionalidade)

        cursor.execute(sql, valores)
        conn.commit()
        print("Registro inserido com sucesso")

    except ValueError as ve:
        print(f"\n ;) \n deu erro na validação: {ve}")
    except mysql.connector.Error as err:
        print(f"\n ;) \n deu erro no banco de dados: {err}")
        if 'conn' in locals():
            conn.rollback()
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals() and conn.is_connected():
            conn.close()

if __name__ == "__main__":
    while True:
        inserir_dados()
        continuar = input("\nInserir outro registro? (S/N): ").upper()
        if continuar != "S":
            break
