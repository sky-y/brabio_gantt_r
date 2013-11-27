# brabio_gantt.R

プロジェクト管理用クラウドツール [Brabio!](http://brabio.jp/)で
エクスポートしたガントチャートCSVを
1枚の図で見やすくするためのRスクリプトです。

Brabio!についての紹介記事は以下を参照してください。

* [職場がExcel主義でもOK！ メンバーやプロジェクトの進捗をガントチャートで管理する「Brabio!」 : ライフハッカー［日本版］](http://www.lifehacker.jp/2013/08/130808brabio.html)

## インストール

### 動作環境
* Mac OS X 10.9 Mavericks
* R 2.15.0 GUI 1.51 Leopard build 64-bit (6148)

WindowsやLinuxの場合は、フォントなどの設定をいじる必要があるかもしれません。

### 必要なもの
* R 本体
* Brabio!からエクスポートしたCSV (brabio_export.csvとする)

### インストール手順

Rコンソールで必要なパッケージをインストールする。

	> install.packages("ggplot2", dependencies=TRUE)
	> install.packages("reshape", dependencies=TRUE)

## 使い方
大まかな手順としては、まずグラフを直接出力して出力イメージを確認し(is.output=FALSE)、その後でPDF出力(is.output=TRUE)します。

### 1. brabio_gantt.Rを開いて設定を編集する

ファイル末尾の設定部分をいじります。

入手したCSVの名前(brabio_export.csv)を自分のCSVファイル名に変更し、is.outputをFALSE (グラフを直接出力)にします。

	input.csv <- "brabio_export.csv" #入力(CSV)
	output <- "brabio_gantt.pdf" 
	is.output = FALSE # 直接グラフを出力する場合はFALSEにする

### 2. brabio_gantt.R を読み込む(source)
Macの場合、command-Eで開いているRソースを読み込めます。

### 3. Rコンソールでグラフプロットを実行する
Rコンソールで以下を打ち込むと、グラフが表示されます。

	> myplot

グラフウィンドウのサイズを適当に変更して、出力グラフの形を整えてください。

### 4. PDFでグラフを出力する

先ほどと同様に、ファイル末尾の設定部分をいじります。

出力PDFファイル名を適当に決めて、is.outputをTRUE（PDFにグラフ出力）にします。

	output <- "brabio_gantt.pdf" 
	is.output = TRUE # PDFにグラフを出力する場合はTRUE

最後に、もう一回brabio_gantt.Rを読み込む(source)と、PDFが出力されます。

## おまけ1：ggplot2の紹介

R標準のグラフ機能よりもおしゃれで機能的にも洗練されたグラフライブラリです。

ggplot2の紹介記事は以下にあります：

* [Rのグラフィック作成パッケージ“ggplot2”について｜Colorless Green Ideas](http://id.fnshr.info/2011/10/22/ggplot2/)

## おまけ2：おすすめの環境
[RStudio](http://www.rstudio.com/)というIDEがおすすめです。

解説については [Rstudio事始め](http://www.slideshare.net/TakashiYamane1/rstudio) を参考にしてみてください。