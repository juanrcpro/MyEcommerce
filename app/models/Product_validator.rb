class ProductValidator < ActiveModek::Validator
    def validate_stock(stock_num)
        self.validate(stock_num)
    end
    def validate(stock_num)
        stock_num.errors.add(:stock,'El Stock no puede ser un valor negativo') if stock_num.stock < 0
    end



end