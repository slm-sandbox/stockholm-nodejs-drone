var client = null;

exports.init = function (_client) {
  client = _client;
}

var speed = 1;

exports.takeoff = function() {
  client.takeoff();
};

exports.land = function() {
  client.stop();
  client.land();
};

exports.stop = function() {
  detectFaces = false;
  client.stop();
};

exports.up = function() {
  client.up(speed);
};

exports.upStop = function() {
  client.up(0);
};

exports.down = function() {
  client.down(speed);
};

exports.downStop = function() {
  client.down(0);
};

exports.clockwise = function() {
  client.clockwise(speed);
};

exports.clockwiseStop = function() {
  client.clockwise(0);
};

exports.counterClockwise = function() {
  client.counterClockwise(speed);
};

exports.counterClockwiseStop = function() {
  client.counterClockwise(0);
};

exports.front = function() {
  client.front(speed);
};

exports.frontStop = function() {
  client.front(0);
};

exports.back = function() {
  client.back(speed);
};

exports.backStop = function() {
  client.back(0);
};

exports.right = function() {
  client.right(speed);
};

exports.rightStop = function() {
  client.right(0);
};

exports.left = function() {
  client.left(speed);
};

exports.leftStop = function() {
  client.left(0);
};

exports.flipLeft = function() {
  client.animate("flipLeft", 1000);
};

exports.flipRight = function() {
  client.animate("flipRight", 1000);
};

exports.vzDance = function() {
  client.animate("vzDance", 1000);
};

exports.disableEmergency = function () {
  client.disableEmergency();
};
