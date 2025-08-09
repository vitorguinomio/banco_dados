import psycopg2
from datetime import datetime

def calcular_idade(nasc):
    if nasc is None:
        return None
    hoje = datetime.now()
    return hoje.year - nasc.year - ((hoje.month, hoje.day) < (nasc.month, nasc.day))

def calcular_imc(peso, altura):
    return peso / (altura ** 2)

try:
    nome_desejado = input("Digite o nome da pessoa: ").strip()
    sobrenome_desejado = input("Digite o nome da pessoa desejada: ").strip()

    conn = psycopg2.connect(
        host="localhost",
        database="peso",
        user="vitor",
        password="133122"
    )

    cursor = conn.cursor()
    cursor.execute(
        "SELECT nome, nasc, peso, altura, sexo FROM paciente WHERE nome = %s AND sobrenome = %s;", (nome_desejado, sobrenome_desejado))
    pessoa = cursor.fetchone()

    if pessoa:
        nome, nasc, peso, altura,sexo = pessoa
        idade = calcular_idade(nasc)
        imc = calcular_imc(float(peso), float(altura))

        print("\nRELATÓRIO DE SAÚDE")
        print("=" * 50)
        print(f"\nNome: {nome}")
        print(f"Idade: {idade} anos")
        print(f"Peso: {peso} kg | Altura: {altura} m")
        print(f"Sexo:{sexo}")
        print(f"IMC: {imc:.2f} - ", end="")

        if imc < 18.5:
            print("Abaixo do peso")
        elif 18.5 <= imc < 25:
            print("Peso normal")
        elif 25 <= imc < 30:
            print("Sobrepeso")
        else:
            print("Obesidade")
        print("\n" + "=" * 50)
    else:
        print(f"Nenhuma pessoa encontrada com o ID {nome_desejado}")

except psycopg2.Error as err:
    print(f"Erro de conexão ou consulta: {err}")

except ValueError:
    print("ID inválido. Por favor, digite um número inteiro.")

finally:
    try:
        if conn:
            cursor.close()
            conn.close()
            print("Conexão encerrada.")
    except NameError:
        pass
