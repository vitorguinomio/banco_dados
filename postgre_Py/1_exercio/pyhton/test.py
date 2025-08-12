import psycopg2
import pandas as pd
from openai import OpenAI

# 🧠 CLIENTE CONECTADO À SUA API LOCAL DO OCHAT
client = OpenAI(
    api_key="not-needed",  # Pode ser qualquer valor (o servidor local ignora)
    base_url="http://localhost:8000/v1"  # URL do servidor local OChat
)

# 📦 Conectando ao PostgreSQL
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="peso",
    user="postgres",
    password="133122"
)

# 🔎 Carregar dados da tabela
query = """
    SELECT nome, nacionalidade, peso, altura
    FROM paciente
    WHERE peso IS NOT NULL AND altura IS NOT NULL AND altura > 0;
"""

df = pd.read_sql_query(query, conn)

# ➗ Calcular IMC
df['imc'] = df['peso'] / (df['altura'] ** 2)

# 🧹 Normalizar nacionalidades (evita erro de maiúsculas/minúsculas)
df['nacionalidade'] = df['nacionalidade'].str.upper()

# 📊 IMC médio por nacionalidade
imc_por_pais = df.groupby('nacionalidade')['imc'].mean().reset_index()
print("✅ IMC médio por nacionalidade:\n", imc_por_pais)

# 🤖 Função para gerar explicação usando a LLM local
def gerar_explicacao(pais1, pais2, imc1, imc2):
    prompt = f"""
    Os dados mostram que o IMC médio de pacientes do {pais1} é {imc1:.2f}, enquanto do {pais2} é {imc2:.2f}.
    Com base em fatores culturais, sociais, econômicos e alimentares, explique por que o IMC pode ser maior em um país do que no outro.
    Dê uma resposta clara, com possíveis causas, e cite fatos reais se possível.
    """

    response = client.chat.completions.create(
        model="openchat/openchat-3.5-0106",  # Esse deve ser o mesmo modelo carregado no servidor
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7
    )

    return response.choices[0].message.content

# 🌎 Comparar dois países
pais1 = "BRASIL"
pais2 = "EUA"

if pais1 in imc_por_pais['nacionalidade'].values and pais2 in imc_por_pais['nacionalidade'].values:
    imc1 = imc_por_pais[imc_por_pais['nacionalidade'] == pais1]['imc'].values[0]
    imc2 = imc_por_pais[imc_por_pais['nacionalidade'] == pais2]['imc'].values[0]

    explicacao = gerar_explicacao(pais1, pais2, imc1, imc2)
    print(f"\n📘 Explicação gerada pela LLM ({pais1} vs {pais2}):\n{explicacao}")
else:
    print(f"❌ Erro: não foram encontrados dados para {pais1} ou {pais2}.")
