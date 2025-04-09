from machine import Pin, I2C
import time
from time import sleep

class MPU6050:
    def __init__(self, i2c, addr=0x68):
        self.i2c = i2c
        self.addr = addr
        # Wake up the sensor (exit sleep mode)
        try:
            self.i2c.writeto_mem(self.addr, 0x6B, b'\x00')
            time.sleep_ms(10)  # Small delay to let it settle
        except OSError:
            raise Exception("Failed to initialize MPU6050. Check wiring and address.")

    def read_raw_data(self, reg):
        data = self.i2c.readfrom_mem(self.addr, reg, 2)
        value = int.from_bytes(data, 'big')
        if value > 32767:
            value -= 65536
        return value

    def get_accel(self):
        ax = self.read_raw_data(0x3B)
        ay = self.read_raw_data(0x3D)
        az = self.read_raw_data(0x3F)
        return ax, ay, az

# Set up I2C with your pins (SDA = GPIO22, SCL = GPIO23)
i2c = I2C(0, scl=Pin(23), sda=Pin(22), freq=400000)

# Initialize MPU6050
mpu = MPU6050(i2c)

while True:
    ax, ay, az = mpu.get_accel()
    print('Accel X:', ax, 'Y:', ay, 'Z:', az)
    sleep(0.01)
