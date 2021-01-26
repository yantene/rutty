![Rutty](./artwork/logo.png)

Rutty はチャットツールで投稿されたコード片を環境で実行し、結果を表示する bot です。
本リポジトリではコード片を含むリクエストを投げると、その結果を返す HTTP サーバを提供します。

```
$ docker-compose up --build -d
$ curl http://localhost:3000/executors/bash \
    -H "Content-Type: application/json" \
    --data '{"code": "echo hello; echo world >&2; exit 42"}' | jq .
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    94    0    47  100    47    135    135 --:--:-- --:--:-- --:--:--   270
{
  "stdout": "hello\n",
  "stderr": "world\n",
  "rc": 42
}
```

ノリで適当に作ったので、**悪意ある入力に脆弱な可能性があります**。
信頼できるメンバーのみがアクセスできる環境でご利用ください。

## 対応言語

現在、以下の言語に対応しています。

- Bash
- PHP
- Ruby

## 対応チャットツール

- [Slack](/k1hiiragi/rutty-slack)
