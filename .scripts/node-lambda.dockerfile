FROM public.ecr.aws/lambda/nodejs:16

COPY package*.json ./

RUN npm install --production

COPY . ${LAMBDA_TASK_ROOT}
COPY server/serverless.js ${LAMBDA_TASK_ROOT}

CMD [ "serverless.handler" ]
