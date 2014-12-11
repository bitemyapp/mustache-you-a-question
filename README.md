# THESE BENCHMARK RESULTS ARE NOT FINAL, I AM STILL HAMMERING THINGS OUT


# Benchmark results


## Clojure

### Simple, small template

```
Evaluation count : 14526 in 6 samples of 2421 calls.
             Execution time mean : 49.807356 µs
    Execution time std-deviation : 11.634874 µs
   Execution time lower quantile : 41.717283 µs ( 2.5%)
   Execution time upper quantile : 69.456727 µs (97.5%)
                   Overhead used : 10.589702 ns

Found 1 outliers in 6 samples (16.6667 %)
	low-severe	 1 (16.6667 %)
 Variance from outliers : 64.5456 % Variance is severely inflated by outliers
```

### Big template (small template * 100)

```
Evaluation count : 144 in 6 samples of 24 calls.
             Execution time mean : 3.936954 ms
    Execution time std-deviation : 311.294446 µs
   Execution time lower quantile : 3.581855 ms ( 2.5%)
   Execution time upper quantile : 4.342500 ms (97.5%)
                   Overhead used : 10.589702 ns
```

## Haskell

### Simple, small template, parsing on the fly

```
benchmarking parse and render small
time                 988.3 ns   (986.5 ns .. 990.8 ns)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 992.9 ns   (989.9 ns .. 997.1 ns)
std dev              11.32 ns   (8.423 ns .. 14.55 ns)
```

### Rendering pre-parsed template

```
benchmarking render small
time                 7.882 ns   (7.836 ns .. 7.923 ns)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 7.833 ns   (7.814 ns .. 7.858 ns)
std dev              72.91 ps   (57.84 ps .. 105.1 ps)
```

### Big template, parsing on the fly

```
benchmarking parse and render big
time                 90.62 μs   (90.47 μs .. 90.82 μs)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 91.47 μs   (91.08 μs .. 91.97 μs)
std dev              1.492 μs   (1.116 μs .. 1.986 μs)
variance introduced by outliers: 10% (moderately inflated)
```

### Rendering pre-parsed big template

```
benchmarking render big
time                 7.850 ns   (7.830 ns .. 7.882 ns)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 7.861 ns   (7.833 ns .. 7.898 ns)
std dev              111.0 ps   (83.60 ps .. 158.8 ps)
variance introduced by outliers: 18% (moderately inflated)
```
