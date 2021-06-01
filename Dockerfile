#nodeイメージをpullする
FROM node:14.15.4-alpine AS build

#working directory
WORKDIR /app

#vuecliインストール
RUN npm install -g @vue/cli
COPY package.json ./

COPY . .

#shファイルをコンテナにコピー
COPY ./scripts/docker.start.sh /scripts/start.sh

#shフォルダの権限追加（全員実行可）
RUN chmod +x /scripts/*

#初期実行
ENTRYPOINT [ "/scripts/start.sh" ]


#FROM nginx:1.17.10
#COPY --from=build /app/dist /usr/share/nginx/html
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]