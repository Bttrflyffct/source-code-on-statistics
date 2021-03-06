#
# Lock & Key
# Author: galaa
# Created on 2016/06/23 11:15:00
#

# өгөгдөхүүн: 5 түлхүүрээс зөвхөн нэг нь цоожинд тохирно
# санамсаргүй хувьсагч: цоожийг тайлах оролдлогын тоо
# олох зүйл: санамсаргүй хувьсагчийн дундаж утга ба стандарт хазайлт
# нөхцөл: шалгагдсан түлхүүрүүдийг дараачийн оролдлогуудад оролцуулахгүй

set.seed(11); tries <- c();
for (i in 1:1000) {
  keys = 5;
  repeat {
    if (runif(n = 1) <= 1 / keys) {
      tries <- c(tries, 5 - keys + 1);
      break;
    }
    keys = keys - 1;
  }
}
mean(tries); sd(tries);
