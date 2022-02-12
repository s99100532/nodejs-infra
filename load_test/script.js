import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
    stages: [
        { duration: '2m', target: 1100 }, // below normal load
        { duration: '5m', target: 1100 },
        { duration: '2m', target: 1200 }, // normal load
        { duration: '5m', target: 1200 },
        { duration: '2m', target: 1300 }, // around the breaking point
        { duration: '5m', target: 1300 },
        { duration: '2m', target: 1400 }, // beyond the breaking point
        { duration: '5m', target: 1400 },
        { duration: '10m', target: 0 }, // scale down. Recovery stage.
    ],
};

export default function () {
    http.get('http://nodejs-infra-1703367659.ap-southeast-1.elb.amazonaws.com');
    sleep(1);
}