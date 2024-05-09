import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MethodChannel, {
  MethodCallHandler,
  MethodResult
} from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import EventChannel, { StreamHandler, EventSink } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import { BinaryMessenger, MethodCodec } from '@ohos/flutter_ohos';
import { TaskQueue } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import sensor from '@ohos.sensor';
import { BusinessError } from '@kit.BasicServicesKit';

/** SensorsPlusOhosPlugin **/
export default class SensorsPlusOhosPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private accelerometerEventChannel: SensorsEventChannel | null = null;
  private userAccelerometerEventChannel: SensorsEventChannel | null = null;
  private gyroscopeEventChannel: SensorsEventChannel | null = null;
  private magnetometerEventChannel: SensorsEventChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "SensorsPlusOhosPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "dev.fluttercommunity.plus/sensors/method");
    this.channel.setMethodCallHandler(this)
    this.accelerometerEventChannel = new SensorsEventChannel(binding.getBinaryMessenger(), sensor.SensorId.ACCELEROMETER);
    this.userAccelerometerEventChannel = new SensorsEventChannel(binding.getBinaryMessenger(), sensor.SensorId.LINEAR_ACCELEROMETER);
    this.gyroscopeEventChannel = new SensorsEventChannel(binding.getBinaryMessenger(), sensor.SensorId.GYROSCOPE);
    this.magnetometerEventChannel = new SensorsEventChannel(binding.getBinaryMessenger(), sensor.SensorId.MAGNETIC_FIELD);

  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }

    if (this.accelerometerEventChannel != null) {
      this.accelerometerEventChannel.onDetachedFromEngine();
      this.accelerometerEventChannel = null;
    }
    if (this.userAccelerometerEventChannel != null) {
      this.userAccelerometerEventChannel.onDetachedFromEngine();
      this.userAccelerometerEventChannel = null;
    }
    if (this.gyroscopeEventChannel != null) {
      this.gyroscopeEventChannel.onDetachedFromEngine();
      this.gyroscopeEventChannel = null;
    }
    if (this.magnetometerEventChannel != null) {
      this.magnetometerEventChannel.onDetachedFromEngine();
      this.magnetometerEventChannel = null;
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "setAccelerationSamplingPeriod") {
      this.accelerometerEventChannel?.setSamplingPeriod(call.args as number);
      result.success(null)
    }
    else if (call.method == "setGyroscopeSamplingPeriod") {
      this.gyroscopeEventChannel?.setSamplingPeriod(call.args as number);
      result.success(null)
    }
    else if (call.method == "setUserAccelerometerSamplingPeriod") {
      this.userAccelerometerEventChannel?.setSamplingPeriod(call.args as number);
      result.success(null)
    }
    else if (call.method == "setMagnetometerSamplingPeriod") {
      this.magnetometerEventChannel?.setSamplingPeriod(call.args as number);
      result.success(null)
    }
    else {
      result.notImplemented()
    }
  }
}


class SensorsEventChannel extends EventChannel {
  private handler: SensorsStreamHandler | null = null;

  constructor(messenger: BinaryMessenger, type: sensor.SensorId, codec?: MethodCodec, taskQueue?: TaskQueue) {
    let name: string = '';
    switch (type) {
      case sensor.SensorId.ACCELEROMETER:
        name = 'dev.fluttercommunity.plus/sensors/accelerometer';
        break;
      case sensor.SensorId.LINEAR_ACCELEROMETER:
        name = 'dev.fluttercommunity.plus/sensors/user_accel';
        break;
      case sensor.SensorId.GYROSCOPE:
        name = 'dev.fluttercommunity.plus/sensors/gyroscope';
        break;
      case sensor.SensorId.MAGNETIC_FIELD:
        name = 'dev.fluttercommunity.plus/sensors/magnetometer';
        break;
      default:
        break;
    }
    super(messenger, name, codec, taskQueue);
    this.handler = new SensorsStreamHandler(type);
    this.setStreamHandler(this.handler);
  }

  onDetachedFromEngine(): void {
    this.setStreamHandler(null);
    if (this.handler != null) {
      this.handler.unsubscribe();
      this.handler = null;
    }
  }

  setSamplingPeriod(microseconds: number): void {
    this.handler?.setSamplingPeriod(microseconds);
  }
}

class SensorsStreamHandler implements StreamHandler {
  constructor(type: sensor.SensorId) {
    this.type = type;
  }

  type: sensor.SensorId;
  samplingPeriod: number = 200000;
  private events: EventSink | null = null;
 // private  eventMap: Map<sensor.SensorId, EventSink> = new Map<sensor.SensorId, EventSink>();

  setSamplingPeriod(microseconds: number): void {
    this.samplingPeriod = microseconds;
    this.subscribe();
  }

  onListen(args: ESObject, events: EventSink): void {
    this.events = events;
    this.subscribe();
  }

  onCancel(args: ESObject): void {
    this.unsubscribe();
    this.events = null;
  }

  subscribe(): void {
    try {
      this.unsubscribe();
      switch (this.type) {
        case sensor.SensorId.ACCELEROMETER:
          sensor.on(this.type, this.onCallBack.bind(this), { interval: this.samplingPeriod });
          break;
        case sensor.SensorId.LINEAR_ACCELEROMETER:
          sensor.on(this.type, this.onCallBack.bind(this), { interval: this.samplingPeriod });
          break;
        case sensor.SensorId.GYROSCOPE:
          sensor.on(this.type, this.onCallBack.bind(this), { interval: this.samplingPeriod });
          break;
        case sensor.SensorId.MAGNETIC_FIELD:
          sensor.on(this.type, this.onCallBack.bind(this), { interval: this.samplingPeriod });
          break;
        default:
          break;
      }

    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }
  }

  unsubscribe(): void {
    switch (this.type) {
      case sensor.SensorId.ACCELEROMETER:
        sensor.off(this.type, this.onCallBack.bind(this));
        break;
      case sensor.SensorId.LINEAR_ACCELEROMETER:
        sensor.off(this.type, this.onCallBack.bind(this));
        break;
      case sensor.SensorId.GYROSCOPE:
        sensor.off(this.type, this.onCallBack.bind(this));
        break;
      case sensor.SensorId.MAGNETIC_FIELD:
        sensor.off(this.type, this.onCallBack.bind(this));
        break;
      default:
        break;
    }
  }

  onCallBack(data: sensor.AccelerometerResponse): void {
    this.events?.success([data.x, data.y, data.z]);
  }
}

