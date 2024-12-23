FROM python:3.7-slim
ARG mode
ENV MODE=${mode}
RUN apt-get update && apt-get install -y \
curl \
gnupg \
&& echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
| tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
&& curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
&& apt-get update -y \
&& apt-get install -y google-cloud-cli 

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    lsb-release \
    ca-certificates && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-13    
    
WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt  


CMD ["sleep", "infinity"]


#Second stage of the build
# FROM python:3.7-slim 

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     libpq5

# COPY --from=builder /usr/lib/google-cloud-sdk /usr/lib/google-cloud-sdk
# COPY --from=builder /usr/bin/gcloud /usr/bin/gcloud
# COPY --from=builder /usr/lib/postgresql/ /usr/lib/postgresql/
# COPY --from=builder /app /app

# ENV PATH="/usr/lib/google-cloud-sdk/bin:/usr/lib/postgresql/13/bin:${PATH}"

# WORKDIR /app