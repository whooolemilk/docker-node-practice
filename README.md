# docker-node-practice

1. Dockerfile を作成

   ```
   FROM node:18.16.0-alpine
   ```

2. docker-compose.yaml を作成

   ```yaml
    version: "3.9"
    services:
      node:
        build:
          context: ./front
          dockerfile: Dockerfile
        container_name: rsc-blog
        ports:
          - 3000:3000 # Next.js
        volumes:
          - type: bind
            source: ./front
            target: /home/app
   ```

3. `docker compose run --rm node sh`を実行し、コンテナにはいる

4. `cd /home/app`を実行し、/home/app内でyarn3 の最新版の設定を行う

   ```sh
   $ corepack enable
   $ corepack prepare yarn@3.5.0 --activate

   $ yarn init
   # yarn.lock や README.md が生成される

   $ yarn set version 3.5.0
   # .yarn/release に yarn の binary が保存される

   $ yarn -v
   # 3.5.0と返ってきたら設定完了
   ```

   ※ここで出る`Internal Error: Process git failed to spawn...`はコンテナに git が入っていないから

5. `yarn init`で作られたファイルで必要のないものを削除

6. .gitignore の`!.yarn/cache`から!を削除

7. .yarnrc.yml に`nodeLinker: node-modules`を追記

8. docker-compose.yaml に以下を追記し、node_modules のフォルダを volume-mount する

   ```yaml
          - type: volume
            source: node-modules-volume
            target: /home/app/node_modules
    volumes:
      node-modules-volume:
   ```

9. docker-compose.yaml を書き換えたので、もう一度`docker compose run --rm node sh`を実行し、コンテナにはいりなおす

   ※コンテナ起動時に`Volume "<コンテナ名>_node-modules-volume"  Created`と出てきたら、volume-mount された証拠

10. package.json に欲しいライブラリなどを`yarn add`していく

    ```sh
    # 例）
    $ yarn add next react react-dom typescript
    $ yarn add -D @types/node @types/react @types/react-dom

    ```

11. Dockerfile に以下を追記し、

    ```Dockerfile
    ENV APP_ROOT /home/app

    WORKDIR $APP_ROOT

    COPY ./.yarnrc.yml ./package.json ./yarn.lock $APP_ROOT
    COPY ./.yarn ./.yarn

    RUN corepack enable
    RUN yarn install
    COPY . $APP_ROOT

    EXPOSE 3000

    CMD ["yarn", "dev"]
    ```

12. .dockerignore を作成し、`./node_moduels`を書く
    ※`COPY . $APP_ROOT`をするときに、ローカルの node_modules をコンテナにコピーしないように

13. `docker compose build`でコンテナをビルド

14. そのほか、必要なファイルを追加していく

- src/pages/index.ts
- .prettierrc.js
- next-env.d.ts
- next.config.js
- tsconfig.json 　など

15. `docker compose up`で localhost:3000 が開けたら環境構築終了！