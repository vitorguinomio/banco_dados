import psycopg2
from datetime import datetime
from transformers import pipeline
import pandas as pd


def calcular_idade(nasc):
    if nasc is None:
        return None
    hoje = datetime.now()
    return hoje.year - nasc.year - ((hoje.month, hoje.day) < (nasc.month, nasc.day))

def calcular_imc(peso, altura):
    return peso / (altura ** 2)

def conector_banco():
    return psycopg2.connect(
        host="localhost",
        database="peso",
        user="vitor",
        password="133122"
    )

def paciente_imc():

    try:
        nome_desejado = input("Digite o nome da pessoa: ").strip().upper()
        sobrenome_desejado = input("Digite o nome da pessoa desejada: ").strip().upper()

        conn = conector_banco()
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
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()

def paciente_pais():

    try:
        conn = conector_banco()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT COUNT(*) FROM paciente;"
        )
        quant = cursor.fetchone()
        print(quant)

    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()

def analise_AI():
    conn = None
    cursor = None
    try:
        # Conectar ao banco e consultar dados
        conn = conector_banco()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT nacionalidade, AVG(peso / (altura * altura)) AS imc_medio, COUNT(*) AS total_pacientes "
            "FROM paciente GROUP BY nacionalidade;"
        )
        df = pd.DataFrame(cursor.fetchall(), columns=['nacionalidade', 'imc_medio', 'total_pacientes'])

        # Análise com IA
        try:
            analisador = pipeline("text-generation", model="gpt2")
            prompt = (
                "Analise em português os dados de IMC por nacionalidade:\n"
                f"{df.to_string(index=False)}\n\n"
                "Liste:\n1. Países com IMC > 25:\n2. Países com IMC ≤ 25:\n3. País com mais pacientes:\n"
            )
            resposta = analisador(prompt, max_new_tokens=500, truncation=True, do_sample=True, temperature=0.7)[0]['generated_text']
            print("\n--- Análise Automática ---\n", resposta)
        except Exception as e:
            print(f"\n--- Erro na Análise com IA: {e} ---")

        # Análise manual (fallback)
        print("\n--- Análise Manual ---")
        above_25 = df[df['imc_medio'] > 25][['nacionalidade', 'imc_medio']]
        below_25 = df[df['imc_medio'] <= 25][['nacionalidade', 'imc_medio']]
        max_patients = df.loc[df['total_pacientes'].idxmax()]

        print("1. Países com IMC médio acima de 25:")
        print("\n".join(f"   - {row['nacionalidade']}: {row['imc_medio']:.2f}" for _, row in above_25.iterrows()) or "   Nenhum país.")

        print("2. Países com IMC médio abaixo ou igual a 25:")
        print("\n".join(f"   - {row['nacionalidade']}: {row['imc_medio']:.2f}" for _, row in below_25.iterrows()) or "   Nenhum país.")

        print(f"3. País com maior número de pacientes: {max_patients['nacionalidade']} ({max_patients['total_pacientes']} pacientes)")

    except Exception as e:
        print(f"Erro: {e}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
            
if __name__ == "__main__":
    while True:
        modo = input("\n[1] Calcular ICM de paciente\n[2] Contagem de paises\n[3] analise do banco de dados por LLM \n Escolha: ")
        if modo == "1":
            paciente_imc()
        elif modo == "2":
            paciente_pais()
        elif modo == "3":
            analise_AI()
        else:
            print("Opcao invalida")
        
        continuar = input("\n pretende continuar? (S/N)").upper()
        if continuar != "S":
            break
