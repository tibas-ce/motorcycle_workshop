# Limpar dados existentes (cuidado em produção!)
puts "Limpando dados..."
ReviewPart.destroy_all
Review.destroy_all
Scheduling.destroy_all
Motorcycle.destroy_all
ModelPart.destroy_all
Part.destroy_all
MotorcycleModel.destroy_all
Mechanic.destroy_all
User.destroy_all

puts "Criando usuários..."

# Admin
admin = User.create!(
  email: 'admin@royalenfield.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Administrador',
  phone_number: '(83) 99999-0001',
  role: 'admin'
)

# Mecânicos
mecanico1_user = User.create!(
  email: 'carlos@royalenfield.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Carlos Silva',
  phone_number: '(83) 99999-0002',
  role: 'mecanico'
)

mecanico1 = Mechanic.create!(
  user: mecanico1_user,
  professional_registration: 'MEC-001',
  specialty: 'Motor e Transmissão',
  ativo: true
)

mecanico2_user = User.create!(
  email: 'jose@royalenfield.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'José Santos',
  phone_number: '(83) 99999-0003',
  role: 'mecanico'
)

mecanico2 = Mechanic.create!(
  user: mecanico2_user,
  professional_registration: 'MEC-002',
  specialty: 'Elétrica e Suspensão',
  ativo: true
)

# Clientes
cliente1 = User.create!(
  email: 'joao@email.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'João Pedro Silva',
  phone_number: '(83) 99999-1001',
  address: 'Rua das Flores, 123 - Tambaú',
  role: 'cliente'
)

cliente2 = User.create!(
  email: 'maria@email.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Maria Santos',
  phone_number: '(83) 99999-1002',
  address: 'Av. Epitácio Pessoa, 456 - Cabo Branco',
  role: 'cliente'
)

puts "Criando modelos de motos..."

meteor = MotorcycleModel.create!(
  name: 'Meteor 350',
  displacement: 350,
  start_production_year: 2020,
  description: 'Cruiser clássica com motor de 350cc',
  warranty_months: 36,
  warranty_km: 30000
)

himalayan = MotorcycleModel.create!(
  name: 'Himalayan 450',
  displacement: 450,
  start_production_year: 2023,
  description: 'Adventure touring com alta capacidade off-road',
  warranty_months: 36,
  warranty_km: 30000
)

interceptor = MotorcycleModel.create!(
  name: 'Interceptor 650',
  displacement: 650,
  start_production_year: 2018,
  description: 'Café racer com motor bicilíndrico paralelo',
  warranty_months: 36,
  warranty_km: 30000
)

puts "Criando peças..."

# Peças de Motor
oil_engine = Part.create!(
  name: 'Óleo Motor 20W50 Semi-Sintético',
  original_code: 'RE-OL-001',
  price: 85.00,
  stock: 30,
  category: 'Motor',
  description: 'Óleo original Royal Enfield para motores 350cc e 450cc'
)

oil_650 = Part.create!(
  name: 'Óleo Motor 10W40 Sintético',
  original_code: 'RE-OL-002',
  price: 120.00,
  stock: 20,
  category: 'Motor',
  description: 'Óleo sintético para motores 650cc'
)

filter_oil = Part.create!(
  name: 'Filtro de Óleo',
  original_code: 'RE-FO-001',
  price: 45.00,
  stock: 50,
  category: 'Motor',
  description: 'Filtro de óleo compatível com todos os modelos'
)

# Peças de Transmissão
chain = Part.create!(
  name: 'Corrente de Transmissão',
  original_code: 'RE-CT-001',
  price: 280.00,
  stock: 15,
  category: 'Transmissão',
  description: 'Corrente O-ring 520 de alta resistência'
)

crown = Part.create!(
  name: 'Coroa Traseira 42 Dentes',
  original_code: 'RE-CR-001',
  price: 220.00,
  stock: 10,
  category: 'Transmissão',
  description: 'Coroa traseira de 42 dentes, aço de alta durabilidade, para modelos 350cc'
)

sprocket = Part.create!(
  name: 'Pinhão 15 Dentes',
  original_code: 'RE-PI-001',
  price: 95.00,
  stock: 15,
  category: 'Transmissão',
  description: 'Pinhão de 15 dentes, garante a relação ideal de transmissão para motorizações de baixa cilindrada'
)

# Peças de Freio
brake_pad = Part.create!(
  name: 'Pastilha de Freio Dianteiro',
  original_code: 'RE-PF-001',
  price: 120.00,
  stock: 25,
  category: 'Freio',
  description: 'Pastilha de freio orgânica/semi-metálica para excelente desempenho e durabilidade.'
)

brake_disc = Part.create!(
  name: 'Disco de Freio Dianteiro',
  original_code: 'RE-DF-001',
  price: 280.00,
  stock: 12,
  category: 'Freio',
  description: 'Disco ventilado de freio dianteiro, oferece dissipação de calor superior e frenagem eficaz.'
)

# Peças Elétricas
battery = Part.create!(
  name: 'Bateria 12V 32Ah',
  original_code: 'RE-BAT-001',
  price: 450.00,
  stock: 8,
  category: 'Elétrica',
  description: 'Bateria selada (AGM) de alta capacidade, ideal para motos com maior demanda elétrica.'
)

spark_plug = Part.create!(
  name: 'Vela de Ignição',
  original_code: 'RE-VIG-001',
  price: 35.00,
  stock: 40,
  category: 'Elétrica',
  description: 'Vela de ignição padrão, garante queima de combustível eficiente e partidas rápidas.'
)

puts "Vinculando peças aos modelos..."

# Meteor 350
ModelPart.create!(motorcycle_model: meteor, part: oil_engine, obrigatoria_revisao: true, km_troca: 5000)
ModelPart.create!(motorcycle_model: meteor, part: filter_oil, obrigatoria_revisao: true, km_troca: 5000)
ModelPart.create!(motorcycle_model: meteor, part: chain, obrigatoria_revisao: false, km_troca: 10000)
ModelPart.create!(motorcycle_model: meteor, part: crown, obrigatoria_revisao: false, km_troca: 20000)
ModelPart.create!(motorcycle_model: meteor, part: sprocket, obrigatoria_revisao: false, km_troca: 20000)
ModelPart.create!(motorcycle_model: meteor, part: brake_pad, obrigatoria_revisao: false, km_troca: 15000)
ModelPart.create!(motorcycle_model: meteor, part: brake_disc, obrigatoria_revisao: false, km_troca: 30000)
ModelPart.create!(motorcycle_model: meteor, part: spark_plug, obrigatoria_revisao: false, km_troca: 10000)

# Himalayan 450
ModelPart.create!(motorcycle_model: himalayan, part: oil_engine, obrigatoria_revisao: true, km_troca: 5000)
ModelPart.create!(motorcycle_model: himalayan, part: filter_oil, obrigatoria_revisao: true, km_troca: 5000)
ModelPart.create!(motorcycle_model: himalayan, part: chain, obrigatoria_revisao: false, km_troca: 10000)
ModelPart.create!(motorcycle_model: himalayan, part: brake_pad, obrigatoria_revisao: false, km_troca: 15000)
ModelPart.create!(motorcycle_model: himalayan, part: battery, obrigatoria_revisao: false, km_troca: 60000)
ModelPart.create!(motorcycle_model: himalayan, part: spark_plug, obrigatoria_revisao: false, km_troca: 10000)

# Interceptor 650
ModelPart.create!(motorcycle_model: interceptor, part: oil_650, obrigatoria_revisao: true, km_troca: 6000)
ModelPart.create!(motorcycle_model: interceptor, part: filter_oil, obrigatoria_revisao: true, km_troca: 6000)
ModelPart.create!(motorcycle_model: interceptor, part: chain, obrigatoria_revisao: false, km_troca: 12000)
ModelPart.create!(motorcycle_model: interceptor, part: brake_disc, obrigatoria_revisao: false, km_troca: 30000)
ModelPart.create!(motorcycle_model: interceptor, part: battery, obrigatoria_revisao: false, km_troca: 60000)
