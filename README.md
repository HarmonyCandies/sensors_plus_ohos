# sensors_plus_ohos

[![pub package](https://img.shields.io/pub/v/sensors_plus_ohos.svg)](https://pub.dartlang.org/packages/sensors_plus_ohos)
[![GitHub stars](https://img.shields.io/github/stars/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/network)
[![GitHub license](https://img.shields.io/github/license/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/issues)
![HarmonyCandies QQ 群](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fharmonycandies%2F.github%2Frefs%2Fheads%2Fmain%2Fdata.yml&query=%24.qq_group_number&label=QQ%E7%BE%A4&logo=qq&color=1DACE8)

Flutter plugin for accessing accelerometer, gyroscope, magnetometer, and barometer sensors On OpenHarmony.

The OpenHarmony implementation of [`sensors_plus`][1].

[`sensors_plus`][1] 在 OpenHarmony 平台的实现。

## 使用

```yaml
dependencies:
  sensors_plus: 6.1.1
  sensors_plus_ohos: 0.1.0
```

在你的项目的 `module.json5` 文件中增加以下权限设置。

```json
    requestPermissions: [
      {"name" :  "ohos.permission.ACCELEROMETER"},
      {"name" :  "ohos.permission.GYROSCOPE"},
    ],
```

 [1]: https://pub.dev/packages/sensors_plus
