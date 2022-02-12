import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
    stages: [
        { duration: '2m', target: 2100 }, // below normal load
        { duration: '5m', target: 2100 },
        { duration: '2m', target: 2200 }, // normal load
        { duration: '5m', target: 2200 },
        { duration: '2m', target: 2300 }, // around the breaking point
        { duration: '5m', target: 2300 },
        { duration: '2m', target: 2400 }, // beyond the breaking point
        { duration: '5m', target: 2400 },
        { duration: '10m', target: 0 }, // scale down. Recovery stage.
    ],
};

export default function () {
    http.get(__ENV.MY_URL);
    sleep(1);
}