class Batch::DataReset
  def self.data_reset
    Book.delete_all
    p "投稿を定期処理で全て削除しました"
  end
end
