# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  title      :string
#  code       :string
#  stock      :integer          default(0)
#  price      :decimal(10, 2)   default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord

    #has_many :shopping_carts
    has_many :shopping_cart_products

    #CALLBACKS
    before_save :validate_product #se ejecuta antes del metodo save
    after_save :send_notification #se ejecuta despues del metodo save
    after_save :push_notification, if: :discount?
    #around_update >>> se ejecuta durante el suceso del metodo
    before_update :code_notification_changed, if: :code_changed?
    after_update :send_notification_stock, if: :stock_limit?

    #VALIDACIONES
    #campo obligatorio
    validates :title, presence: {message: 'Es necesario ingresar el nombre del producto para su cracion'}
    validates :code, presence: {message: 'Es necesario ingresar el codigo del producto para su cracion'}

    #Campo unico no repetido
    validates :code, uniqueness: {message: 'El codigo: %{value} ya se encuentra registrado a un producto'}

    #Valida el tamaño este dentro del rango de caracteres, condicionada si hay valor mayor a 0
    #validates :price, length: {minimum:5, maximum:10}
    validates :price, length: {in: 3...11, message: 'El precio esta fuera de rango'}, if: :has_price?
    #Validaciones propias
    validate :code_validate

    #Validaciones propias
    #validates_with ProductValidator

    #SCOPE Consultas preestablecidas comunes entre modelos (llamdas desde consola)
    scope :available, -> {where('stock >= ?',8)}
    scope :available, ->(min=1) {where('stock >= ?',min)} #metodo scope con parametro
    scope :order_price_desc, ->{order('price DESC')}
    scope :available_orderpricedesc, ->{available.order_price_desc} #concatenar scope

    #Metodo de la clase
    def self.top_5_avaliable
        self.available.order_price_desc.limit(5).select(:title, :code, :price)
    end



    def has_price?
    self.price.nil? && self.price > 0
    end

    def stock_limit?
        self.saved_change_to_stock? && self.stock <= 3
    end


    def total
        self.price
    end

    def discount?
        self.total <50000
    end

    private

    def validate_product
        puts "\n\n\n>>> Un nuevo pŕoducto sera añadido a al almacen!"
    end

    def send_notification
        puts ">>> Un nuevo producto de nombre #{self.title} fua añadido con un costo de $#{self.total}"
        #return puts ">>¡Producto creado con exito!<<" if self.persisted?
    end

    def push_notification
        puts "Se agegado un nuevo producto en descuento dentro del catalogo  <<#{self.title}>>"
    end

    def code_validate
        #validacion
        self.errors.add(:code, 'El codigo debe contener por lo mensos 3 caracteres') if self.code.nil? || self.code.size < 3
        #añadir error al listado
        #self.errors.add(:code, 'El codigo debe contener 3 caracteres')
    end

    def code_notification_changed
        puts "\n\n\n El codigo fue modificado"
    end

    def send_notification_stock
        puts "El producto #{self.title} contiene #{self.stock} ecxistencias en stock"
    end





end
