#
Retorna los valor de la condicion
Product.where(title:'CPU')
#Cuenta los registros retornados
Product.where(title:'CPU').count
#Retorna los registro dentro de la condiciones con AND
Product.where(title:'CPU').where (price:35000).count
Product.where(title:'CPU', price:35000).count
#Retorna los registros que cumplan una condicion
Product.where(title:'CPU')or.(Product.where(Price:35000)).or(Product.where(code:'00010'))
#Operadores Relacionales
Product.where('price <= 10000')
Product.where('price >= ? and code = ?', 15000, '0010')
#Optener registro a partir de id
Product.find(5)
Product.find(5,2,7)
Product.find[5,2,7]
#Optener a partir de una columna condicionada, el primero que cumpla
Product.find_by(code:'0001')
#Ordenar por valor de una columna y limitar cuantos resultados retorna
Product.all.order('price DESC').limit(3)
#Retorna valor bolean, si se cumple la condicion dara true
Product.where('price >= ?', 20000).exists?
#selecciona solo las columnas solicitadas en select(listado de objetos) o pluck(listado de valores)
Product.order('price DESC').limit(5).select(:title, :price)
Product.order('price DESC').limit(5).pluck(:title, :price)
#Valida si el objeto ecxiste y si no procede a crearlo
Product.find_or_create_by(title:'Pc', code:'00010', price:1000000, stock: 6)
#Valida desde condicion un objeto que si no existe lo crea desde un bloque
Product.where(title:'Iphone XR').first_or_create do |p|
    p.code='00012'
    p.price=50000
    p.stock=3
end

#Consultas scope
#SCOPE Consultas preestablecidas comunes entre modelos (llamdas desde consola)
scope :available, -> {where('stock >= ?',8)}
scope :available, ->(min=1) {where('stock >= ?',min)} #metodo scope con parametro

#nos traemos el objeto a trabajar para los ejemplos
producto=Product.first

#Metodos de Update desde consulta
producto.update(title:'Modificado', price:98000)
#update solo un atributo de un objeto (omite validaciones)
producto.update_attribute(:price, 89000)
#update varios atributos de un objeto
producto.update_attributes(title:'Teclado Gamer',code:'00019',price:89000)
#De forma mas rapida y no cuenta las validaciones
producto.update_column(:price, 89000)
producto.update_columns(title:'Teclado Gamer',code:nil,price:-45000)

#Metodos de eliminacion desde consulta
#para eliminar un objeto (registro de la tabla)
producto.destroy
#para eliminar varios
Product.where('price <= ?',-1).destroy_all

#Monitoriar Cambios
#saber si un objeto a sido mopdificado (return bolean)
producto.changed?
# nos indica los cambios insplicitos
producto.changes
#ser mas especifico con el atributo modificado
producto.title_changed?
producto.code_changed?
#conocer el anterior valor del atributo
producto.code_was
#saber si un atributo fue modificado despues de ser percistido (return bolean)
producto.saved_change_to_price?

