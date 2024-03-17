# devcontainer

## 連絡
エラーが起きた場合は、issueで質問してください。

## 使い方

１．dockerの常駐プログラム(デーモン)を起動
ubuntu等のターミナルで、`sudo service start dockerを起動する。

２．vscodeに、拡張機能`Dev Containers`をインストール

３．vscodeで、`ctrl + shift + p`でコマンドパレッドを起動
`dev`と入力し、`DEV CONTAINERS Attach to Running Container`を選択

４．vscodeのintegratedターミナルで、dockerコマンドを起動。
`docker compose up --build`
`.devcontainer` ディレクトリにある、Dockerfileやcompose.yamlを元に、コンテナが起動される




