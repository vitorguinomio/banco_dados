
FROM python:3.9-slim


WORKDIR /app

# Atualiza pip e instala dependências
RUN pip install --upgrade pip \
 && pip install virtualenv ipython jupyterlab pandas

# Expõe a porta do Jupyter Lab
EXPOSE 8888

# Comando para iniciar o Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
