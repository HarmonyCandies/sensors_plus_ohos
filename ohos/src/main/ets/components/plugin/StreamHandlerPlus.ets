import { Any, EventSink, StreamHandler } from '@ohos/flutter_ohos'
import { sensor } from '@kit.SensorServiceKit';
import { systemDateTime } from '@kit.BasicServicesKit';

const timestampMicroAtBoot =
  (systemDateTime.getTime(true) - systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, true)) / 1000;

function transformData(x: number, y: number, z: number, timestamp: number): number[] {
  const timestampSince1970Micro = timestampMicroAtBoot + timestamp / 1000;
  const data = [
    Number.isInteger(x) ? x + 0.00000000001 : x,
    Number.isInteger(y) ? y + 0.00000000001 : y,
    Number.isInteger(z) ? z + 0.00000000001 : z,
    Number.isInteger(timestampSince1970Micro) ? timestampSince1970Micro + 0.00000000001 : timestampSince1970Micro
  ];
  return data;
}

export abstract class SensorStreamHandler implements StreamHandler {
  protected events: EventSink | undefined;
  _samplingPeriod: number = 200000;

  get samplingPeriod(): number {
    return this._samplingPeriod;
  }

  set samplingPeriod(value: number) {
    this._samplingPeriod = value;
    this.didUpdateSamplingPeriod();
  }

  get samplingPeriodInNanos(): number {
    return this._samplingPeriod * 1000;
  }

  protected setupSensor(sensorId: number, callback: (response: sensor.Response) => void): void {
    sensor.on(sensorId, callback, { interval: this.samplingPeriodInNanos });
  }

  protected removeSensor(sensorId: number, callback: (response: sensor.Response) => void): void {
    sensor.off(sensorId, callback);
    this.events = undefined;
  }

  protected updateSensor(sensorId: number, callback: (response: sensor.Response) => void): void {
    sensor.off(sensorId, callback);
    sensor.on(sensorId, callback, { interval: this.samplingPeriodInNanos });
  }

  abstract onListen(args: Any, events: EventSink): void

  abstract onCancel(args: Any): void

  abstract didUpdateSamplingPeriod(): void
}

export class SensorStreamHandlerImpl extends SensorStreamHandler {
  private readonly sensorId: number;
  private readonly eventTransformer: (response: sensor.Response) => number[];

  constructor(
    sensorId: number,
    eventTransformer: (response: sensor.Response) => number[]
  ) {
    super();
    this.sensorId = sensorId;
    this.eventTransformer = eventTransformer;
  }

  onListen(args: Any, events: EventSink): void {
    this.events = events;
    this.setupSensor(this.sensorId, this.callback);
  }

  onCancel(args: Any): void {
    this.removeSensor(this.sensorId, this.callback);
  }

  didUpdateSamplingPeriod(): void {
    this.updateSensor(this.sensorId, this.callback);
  }

  private callback = (response: sensor.Response): void => {
    if (this.events === undefined) {
      return;
    }
    const data = this.eventTransformer(response);
    this.events.success(data);
  };
}

export const AccelerometerStreamHandlerPlus = () => new SensorStreamHandlerImpl(
  sensor.SensorId.ACCELEROMETER,
  (response: sensor.Response) => {
    const resp = response as sensor.AccelerometerResponse;
    return transformData(resp.x, resp.y, resp.z, resp.timestamp);
  }
);

export const UserAccelerometerStreamHandlerPlus = () => new SensorStreamHandlerImpl(
  sensor.SensorId.LINEAR_ACCELEROMETER,
  (response: sensor.Response) => {
    const resp = response as sensor.LinearAccelerometerResponse;
    return transformData(resp.x, resp.y, resp.z, resp.timestamp);
  }
);

export const GyroscopeStreamHandlerPlus = () => new SensorStreamHandlerImpl(
  sensor.SensorId.GYROSCOPE,
  (response: sensor.Response) => {
    const resp = response as sensor.GyroscopeResponse;
    return transformData(resp.x, resp.y, resp.z, resp.timestamp);
  }
);

export const MagnetometerStreamHandlerPlus = () => new SensorStreamHandlerImpl(
  sensor.SensorId.MAGNETIC_FIELD,
  (response: sensor.Response) => {
    const resp = response as sensor.MagneticFieldResponse;
    return transformData(resp.x, resp.y, resp.z, resp.timestamp);
  }
);

export const PressureStreamHandlerPlus = () => new SensorStreamHandlerImpl(
  sensor.SensorId.BAROMETER,
  (response: sensor.Response) => {
    const resp = response as sensor.BarometerResponse;
    const pressure = resp.pressure;
    const timestampSince1970Micro = timestampMicroAtBoot + resp.timestamp / 1000;
    return [
      Number.isInteger(resp.pressure) ? resp.pressure + 0.00000000001 : resp.pressure,
      Number.isInteger(timestampSince1970Micro) ? timestampSince1970Micro + 0.00000000001 : timestampSince1970Micro
    ]
  }
);