/*
 *        Filename:    timing.h
 *
 *     Description:    timing related
 *
 *         Version:    1.0.0.0
 *
 *         Created:    2016-08-25
 *
 *          Author:    miaotianxiang<miaotianxiang@baidu.com>
 *
 *       Copyright:    (C) 2016 Baidu, Inc
 */

#ifndef INF_DA_NOR_API_TIMING_H
#define INF_DA_NOR_API_TIMING_H

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/time.h>

namespace fpga {
namespace rsa {
namespace api {

static inline long time_delta_us(struct timeval *a, struct timeval *b) {
    long delta = (a->tv_sec - b->tv_sec) * 1000000;
    delta += (a->tv_usec - b->tv_usec);
    return delta;
}

static inline struct timeval *my_gettimeofday() {
    struct timeval *tv = (struct timeval *)malloc(sizeof(struct timeval));
    if (gettimeofday(tv, NULL) != 0) {
        free(tv);
        return NULL;
    } else {
        return tv;
    }
}

class StopWatch {
public:
    StopWatch() : _describe(NULL) {
        reset();
    }

    StopWatch(const char *describe) : _describe(describe) {
        reset();
    }

    ~StopWatch() {}

    void reset() {
        _status = NONE;
        timerclear(&_start_time);
        timerclear(&_stop_time);
        _accumulated_timecost = 0ul;
        _stop_cnt = 0ul;
    }

    void restart() {
        gettimeofday(&_start_time, NULL);
        _status = STARTED;
    }

    void start() {
        if (_status == NONE || _status == STOPPED) {
            gettimeofday(&_start_time, NULL);
            _status = STARTED;
        }
    }

    void stop() {
        if (_status == STARTED) {
            gettimeofday(&_stop_time, NULL);
            _status = STOPPED;
            _accumulated_timecost +=
                static_cast<uint64_t>(difference_usec(&_stop_time, &_start_time));
            ++_stop_cnt;
        }
    }

    void stop(uint64_t cnt) {
        if (_status == STARTED) {
            gettimeofday(&_stop_time, NULL);
            _status = STOPPED;
            _accumulated_timecost +=
                static_cast<uint64_t>(difference_usec(&_stop_time, &_start_time));
            _stop_cnt += cnt;
        }
    }

    uint64_t accumulated_timecost_usec() const {
        return _accumulated_timecost;
    }

    void print() const {
        if (_describe != NULL) {
            printf("*** %s : %luus in [%lu] cnt ***\n",
                    _describe,
                    static_cast<unsigned long>(_accumulated_timecost),
                    _stop_cnt);
        } else {
            printf("*** %s : %luus in [%lu] cnt ***\n",
                    "Unknown stop_watch",
                    static_cast<unsigned long>(_accumulated_timecost),
                    _stop_cnt);
        }
    }

    uint64_t timecost_usec() const {
        struct timeval now;
        switch (_status) {
            case STOPPED:
                return static_cast<uint64_t>(difference_usec(&_stop_time, &_start_time));
            case STARTED:
                gettimeofday(&now, NULL);
                return static_cast<uint64_t>(difference_usec(&now, &_start_time));
            default:
                return 0;
        }
    }

    uint64_t timecost_msec() const {
        struct timeval now;
        switch (_status) {
            case STOPPED:
                return static_cast<uint64_t>(difference_msec(&_stop_time, &_start_time));
            case STARTED:
                gettimeofday(&now, NULL);
                return static_cast<uint64_t>(difference_msec(&now, &_start_time));
            default:
                return 0;
        }
    }

    double timecost() const {
        struct timeval now;
        switch (_status) {
            case STOPPED:
                return difference(&_stop_time, &_start_time);
            case STARTED:
                gettimeofday(&now, NULL);
                return difference(&now, &_start_time);
            default:
                return 0;
        }
    }

    double start_time() const {
        return _status == NONE ? 0 : epoch_time(&_start_time);
    }

    double stop_time() const {
        return _status == STOPPED ? epoch_time(&_stop_time) : 0;
    }

    static int64_t difference_usec(const struct timeval *ta, const struct timeval *tb) {
        return static_cast<int64_t>(ta->tv_sec - tb->tv_sec) * 1000000 +
            (ta->tv_usec - tb->tv_usec);
    }

    static int64_t difference_msec(const struct timeval *ta, const struct timeval *tb) {
        return static_cast<int64_t>(ta->tv_sec - tb->tv_sec) * 1000 +
            (ta->tv_usec - tb->tv_usec) / 1000;
    }

    static double difference(const struct timeval *ta, const struct timeval *tb) {
        return 1e-6 * static_cast<double>(ta->tv_usec - tb->tv_usec) +
            static_cast<double>(ta->tv_sec - tb->tv_sec);
    }

    static double epoch_time(const struct timeval *ta) {
        return timerisset(ta) ?
            (1e-6 * static_cast<double>(ta->tv_usec) + static_cast<double>(ta->tv_sec)) : 0;
    }

private:
    enum Status {
        NONE = 0,
        STARTED = 1,
        STOPPED = 2
    };

    struct timeval _start_time;
    struct timeval _stop_time;
    Status _status;
    uint64_t _accumulated_timecost;
    const char *_describe;
    uint64_t _stop_cnt;
};

} // api namespace
} // rsa namespace
} // fpga namespace

#endif // INF_DA_NOR_API_TIMING_H
