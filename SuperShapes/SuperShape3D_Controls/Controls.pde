void m_value_lat(float mValue_lat) {
  m_lat = mValue_lat;
  println("a slider event. setting m-value to " + mValue_lat);
}

void n1_value_lat(float n1Value_lat) {
  n1_lat = n1Value_lat;
  println("a slider event. setting m-value to " + n1Value_lat);
}

void n2_value_lat(float n2Value_lat) {
  n2_lat = n2Value_lat;
  println("a slider event. setting m-value to " + n2Value_lat);
}

void n3_value_lat(float n3Value_lat) {
  n3_lat = n3Value_lat;
  println("a slider event. setting m-value to " + n3Value_lat);
}

void m_value_lon(float mValue_lon) {
  m_lon = mValue_lon;
  println("a slider event. setting m-value to " + mValue_lon);
}

void n1_value_lon(float n1Value_lon) {
  n1_lon = n1Value_lon;
  println("a slider event. setting m-value to " + n1Value_lon);
}

void n2_value_lon(float n2Value_lon) {
  n2_lon = n2Value_lon;
  println("a slider event. setting m-value to " + n2Value_lon);
}

void n3_value_lon(float n3Value_lon) {
  n3_lon = n3Value_lon;
  println("a slider event. setting m-value to " + n3Value_lon);
}

void a_value(float aValue) {
  a = aValue;
  println("a slider event. setting m-value to " + aValue);
}

void b_value(float bValue) {
  b = bValue;
  println("a slider event. setting m-value to " + bValue);
}

void Stripe(float theValue) {
  myColor = color(random(255), random(255), random(255));
  println("a button event. " + theValue);
}

void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getId());
}