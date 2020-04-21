void Car::fillup(Station* station, int slotind, int regind, int amount)
{
    Slot* slot = station->get_slot(slotind);
    Register* reg = station->get_register(regind);
    slot->fill(amount);
    reg->pay(this, slotind);
}

void Car::detract(int amount) { balance-=amount; }