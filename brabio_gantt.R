# 
# brabio_gantt.R
# 
# The MIT License
# 
# Copyright (c) 2013 Yuki Fujiwara
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# 
# brabio_gantt.R
# 
# プロジェクト管理用クラウドツール Brabio!(http://brabio.jp/)でエクスポートしたCSVを
# 1枚の図で見やすくするためのRスクリプトです。
# 

library(ggplot2)
library(reshape)
library(scales)

#
# 日本語をggplotで使えるようにする設定
#

## Mac用フォントの設定
# 参考: http://kohske.wordpress.com/2011/02/26/using-cjk-fonts-in-r-and-ggplot2/
if (Sys.info()[['sysname']] == "Darwin") {
	quartzFonts(HiraKaku=quartzFont(rep("HiraKakuProN-W3", 4)))
}


## カスタムテーマの設定
# 参考: http://d.hatena.ne.jp/triadsou/20100528/1275042816

# 白っぽい背景のテーマ
my_theme_bw <- function (base_size = 25, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(
      axis.text.x = element_text(angle=45, vjust = 0.5) # x軸のテキストを45度傾ける
    )
}

# 灰色っぽい背景のテーマ
my_theme_gray <- function (base_size = 25, base_family = "") {
  theme_gray(base_size = base_size, base_family = base_family) %+replace%
    theme(
      axis.text.x = element_text(angle=45, vjust = 0.5) # x軸のテキストを45度傾ける
    )
}

#
# Brabio CSVファイルの読み込み関数
#

read.brabio.csv <- function (filename = "") {
  plan <- read.csv(filename)
  tasks <- plan[plan$X.タイプ == "task", ] #タスクのみ抽出、マイルストーンは無視
  
  tasks.nrow<- nrow(tasks)
  tasks.name <- tasks$タイトル
  tasks.start.date <- tasks$開始日
  tasks.end.date <- tasks$〆切日
  
  dfr <- data.frame(
    name        = factor(tasks.name, levels = rev(tasks.name)),
    start.date  = tasks.start.date,
    end.date    = tasks.end.date,
    colour = factor(1:tasks.nrow)
  )
  mdfr <- melt(dfr, measure.vars = c("start.date", "end.date"))
  
  return (mdfr)
}


#
# Brabio CSVからガントチャートをプロットする
#
plot.brabio.gantt <- function (input.csv, output, is.output = FALSE, theme.function = my_theme_gray) {
	
	## 実行
	mdfr <- read.brabio.csv(input.csv) 
	
	## グラフをプロット
	base.plot <- ggplot(mdfr, aes(as.Date(value, "%Y/%m/%d"), name, colour = colour)) + 
			      geom_line(size = 6) +
				  xlab("") + ylab("") +
				  scale_x_date(labels = date_format("%Y年%m月")) + theme(legend.position="none")
				  
	if (is.output) {
	  # 画像を出力する場合
	  my.plot <- base.plot + theme.function()
	  ggsave(output, base.plot, family="Japan1GothicBBB")
	} else {
	  # 直接グラフを表示する場合
	  my.plot <- base.plot + theme.function(base_family = "HiraKaku")
	}
	
	return (my.plot)
}


#
# main
#

# ファイル名を指定
input.csv <- "brabio_export.csv" #入力(CSV)
output <- "brabio_gantt.pdf" # 出力(形式は拡張子で自動判別してくれる)
is.output = TRUE # 画像を出力する場合はTRUEに、直接グラフを出力する場合はFALSEにする
theme.function <- my_theme_gray # テーマを指定

myplot <- plot.brabio.gantt(input.csv = input.csv, output = output, is.output = is.output, theme.function = theme.function)

# 設定だけを読み込ませる場合
# sourceしただけでは自動でプロットされないので、以下をコピーしてコンソールに貼り付け・実行する
myplot
