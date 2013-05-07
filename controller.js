var client = null;

exports.init = function (_client) {
  client = _client;
}

exports.takeoff = function () {
    client.takeoff();
};

exports.land = function () {
  client.stop();
  client.land();
};

exports.stop = function () {
  client.stop();
}

exports.up = function () {
  client.up(1);
};

exports.down = function () {
  client.down(1);
};

exports.clockwise = function () {
  client.clockwise(1);
};

exports.counterClockwise = function () {
  client.counterClockwise(1);
};

exports.front = function () {
  client.front(1);
};

exports.back = function () {
  client.back(1);
};

exports.right = function () {
  client.right(1);
};

exports.left = function () {
  client.left(1);
};

exports.flipLeft = function () {
  client.animate('flipLeft', 1500);
};

exports.flipRight = function () {
  client.animate('flipRight', 1500);
};

exports.vzDance = function () {
  client.animate('vzDance', 1500);
};

exports.disableEmergency = function () {
  client.disableEmergency();
};
