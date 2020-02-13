u1 = User.create!(name: 'Valery', email: 'val@ya.ru', password: '123123')
u2 = User.create!(name: 'Maxim', email: 'max@ya.ru', password: '123123')

u1.events.create!(title: 'Birthday', description: "I'm 42!",
  address: 'Smolensk, SanJackue restaurant', datetime: Time.now)
u1.events.create!(title: 'Barbeque', description: "I continue celebrating my birthday",
  address: 'Smolensk, Borovaya Park', datetime: Time.now + 1.week)
