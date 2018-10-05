#!/bin/bash

WORK=15
stem=/tmp/canary$$

trap_exit(){
trap - EXIT INT QUIT TERM
rm -f ${stem}.*
}
trap trap_exit EXIT

id=`hostname`%`date +%s`%`date +%Z`%$WORK

cat <<EOF > $stem.key
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAvP+gFUODj8Je5DA2oQyWAcqB8ZsnLJXNxnpGL3CRiiutnk9h
NAVzeg45znE6vZfY7pKY8McqQ9eV5huirOY3rvqwe8AKEorIaXLKeEHdlaDlORCL
EMDZci4/7EShqtElQQHsKdiy24wuwUvjmcE2AVyEbzkflQkbCjguyO8kAZcZhLyG
KzM4hxOTzycwW1rRvyydPSMMVBnT3vAWl+d7du4VuJLA4ZKQ748WoJaRUnGrEK2B
ymP8xdEpmdSBh/nPOSylsow7+gbEudeis5/Zmss1/bpuekUDc9qYxYtuBFNmrEk5
GO9cY4Fsebw+u6laB01C5DNk7oBe6/Nq8dbqJwIDAQABAoIBAGYKASzZyZL5FvBO
E4B54hdPdT6zTMAmlPWemHwOY5VcpZz+MHW8p67zNUR/H36zF90eatI8RVZhc73L
l9WPaerf0B7P/OAr66362tN4hCC/wGJBy0MdS4j47WwrVbl6t4lUd2PUaiRcl/Wm
elhN11F+2MWP6rw1MVMgKCo16pOsSZ2GQOOmdXa+TSFJ7inpwx0jCcU+uq0eWU+Y
3rKunp1aAzlTvqhBh6d3YEt1uiD7QiqvjOUjan8E8JIDJ82wfgWRz8Yaouh8tkod
b/59UMU2wbgE8iY7ZEgJtA/TjynSOWZDIJKiUYNGCxtG4a69iBY7Sa3pLlG01kND
d+rWxlkCgYEA6VbBRtYSZfR40Q0CH+XB0L/ySaAb5Sdp80lfLQOq1QVot7PMai5w
lkbJaiM1fJ7Vcaf5whTlEXHj4xAaDrbczGIDaGLbiwy+HMvfb/9X3PVopo2Wt6vZ
cMUuPuc0Nqmo0NZMMJTPi7k7n04f6NGdYR9UtT+qkl1AxBdwGQ5VKkUCgYEAz1p8
Tel3m14HVsqwYzkTlLtClSHtFeI8zpORX5KQNNLMvMvR9zI84x3BqPeqvL8W7kIe
jKVSs20b8BB0kN2KhhtPUL7TZ7TnQFLx2iHre+32vj5dRoJESFh9GuPoQFoVsTtT
qu6AwAUkQ5IWwuC2QH33cJISS5UrM7buN6UMX3sCgYAlBINjFoEStacZGyQ0JUIL
OPhaH9FtGEShuQklXgiTBOmpAxgx3C42WQKJGQ7aN2SLRGfGF4SDsPrDQgGwRehf
cEk0HULRG3NppBpNbUfmIPS6P4oil1vGnTGJ/yn0ZhQHFYg+yMzoULmZu04qpF6A
UvUgT/pif/LPaRx6jSCLtQKBgCtTnvGwvPtL9ICgLact//duAYWj5yRRd586mn+7
4kIHYhx5AlCCwNI8H4Es7xItY585VaTRzqwLOnE5HwI+KHnJLxOSLB5ZYJDCRCLu
P4RPvuUVpuvawGXVh56czKTVrf6whNUMrP5ylJdB6VujFLH5IED3ZLdCXhqaOMCL
zkANAoGBAM4Zjpp4FAbEd1Q0u2/z1SZ5qIgA5pGAOBLIFTfKZ/S30JOY2KF0EUMq
2AkPdliJt9N1JQFD6QcyQBxRlndVgLXCf/u0i4Cn/br30ETNhkPiGmNRIgXO4XYP
t9VW0Ylrz/Zeb/dDK5WAYIEQCMU+maogRAQaRi/zvIfzvekaDk9b
-----END RSA PRIVATE KEY-----
EOF
chmod 600 $stem.key

(
echo "start `date` $id"

echo "j(1000, $WORK*1000)" | bash -c "time -p bc -l" > $stem.1 2>&1 &
top -n 1 > $stem.top
vmstat 5 5 > $stem.vm
wait
awk '/real/ { r = $2 }
/user/ { u = $2 }
END { print u, r}' < $stem.1 > $stem.u
ld=`sed -n '/load average/s/.*average: \([^,]*\).*/\1/p' < $stem.top`


echo "=CANARY $id `cat $stem.u` $ld"

echo "=vmstat"; cat $stem.vm
echo "=top"; cat $stem.top
echo "=end"

echo "finish `date` $id"
) > $stem.out
gzip -9 $stem.out
scp -q -o StrictHostKeyChecking=no -i $stem.key $stem.out.gz andrew@75.62.61.55:/mnt/andrew/data/$id.gz
