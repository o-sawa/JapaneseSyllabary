require "japanese_syllabary/version"

module JapaneseSyllabary
  extend self
  # 五十音元データ
  @@data = <<EOS
あ い う え お
かが きぎ くぐ けげ こご
さざ しじ すず せぜ そぞ
ただ ちぢ つづ てで とど
な に ぬ ね の
はばぱ ひびぴ ふぶぷ へべぺ ほぼぽ
ま み む め も
や ゆ よ
ら り る れ ろ
わ
を
ん
EOS

  # 配列の配列のハッシュに変換
  # ex. {'あ'=>[['あ'],['い'],['う'],['え'],['お']], 'か'=>[['か','が']..]..}
  @@syllabary = {}
  @@data.each_line{|line|
    @@syllabary[line[0]] = line.split(' ').map{|x| x.split('') }
  }
  
  # 行音の配列を取得する
  #   Args
  #     is_contains_won : false || true
  #                      「を」「ん」を含むか
  #                       default は false (含まない)
  #   Return
  #     Array : 行音の配列 ex. ['あ','か','さ'..]
  def rows(is_contains_won=false)
    is_contains_won ? @@syllabary.keys : @@syllabary.keys[0...-2]
  end
  
  # 指定行の列音の配列を取得する
  #   Args
  #     row : String || Fixnum
  #           String : 行音 'あ', 'か' など
  #           Fixnum : 行番号 0 なら 'あ', 1 なら 'か'
  #     is_contains_voiced : true || false
  #                          濁音・半濁音を含めるか
  #                          default は true (含める)
  #   Return
  #     Array : 列音の配列 または 列音の配列の配列
  #             is_contains_voiced が false の場合は、列音の配列 ex. ['か','き','く','け','こ']
  #             is_contains_voiced が true  の場合は、列音の配列の配列 ex. [['か','が'],['き','ぎ'],['く','ぐ'],['け','げ'],['こ','ご']]
  def columns(row=-1, is_contains_voiced=true)
    column_list = case row
      when String
        @@syllabary[row] || []
      when Fixnum
        (0...@@syllabary.keys.length).include?(row) ? @@syllabary[@@syllabary.keys[row]] : []
      else
        []
    end
    is_contains_voiced ? column_list : column_list.map{|x| x[0] }.flatten
  end
  
  # 対象名称を比較するように変換する（ひらがなオンリー）
  #   Args
  #     main  : String
  def compare_text(main)
    # 濁点半濁点用
    @substitution_voiced ||= "tr(\"#{@@syllabary.values.flatten(1).select{|x| x.length > 1 }.map{|x| x[1..-1]}.flatten.join()}\",\"#{ @@syllabary.values.flatten(1).select{|x| x.length > 1 }.map{|x| x[0]*(x.length-1) }.join() }\")"
    # 拗促音用
    @substitution_x ||= "tr(\"っぁぃぅぇぉゃゅょゎ\",\"つあいうえおやゆよわ\")"
    # 伸ばし棒用
    @substruction_long ||= rows.map.with_index{|x,i| columns(i,false).index('や') ? "gsub(\"やー\",\"やあ\").gsub(\"ゆー\",\"ゆう\").gsub(\"よー\",\"よう\")" : columns(i,false).map.with_index{|y, j| k = j == 4 ? 2 : j;"gsub(\"#{y}ー\",\"#{y}#{columns(0,false)[k] }\")" } }.flatten.join('.')

    eval("main.#{@substitution_voiced}.#{@substitution_x}.#{@substruction_long}")
  end
end
