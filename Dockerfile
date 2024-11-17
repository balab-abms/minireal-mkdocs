FROM python:3.10
COPY . /minireal_docs/
WORKDIR /minireal_docs/
RUN pip install -r requirements.txt
EXPOSE 8085
CMD ["mkdocs", "serve"]