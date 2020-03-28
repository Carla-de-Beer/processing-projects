// Complex number class

class Complex {
  float re, im;

  Complex(float a, float b) {
    this.re = a;
    this.im = b;
  }

  Complex add(Complex c) {
    float re = this.re += c.re;
    float im = this.im += c.im;
    return new Complex(re, im);
  }

  Complex mult(Complex c) {
    float re = this.re * c.re - this.im * c.im;
    float im = this.re * c.im + this.im * c.re;
    return new Complex(re, im);
  }
}
