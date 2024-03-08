# Signature

- Let's say we add a message and sign it with `private key`
- then it will be converted into `message signature`
- `private key` was hashed with `message` to get the `message signature`
- `private key` + `message` => `signed message`

- Then we can verfiy
- wether the `public key` and the `message`
- matches the `signature`
- `signed message` + `public key` => `confrim signed`

---

### How signing works
1. Take a private key + message (data, function selector, parameters etc...)
2. Smash it into Elliptic Curve Digital Signature Algorith (in a certain format)
   1. This outputs v,r, and s
   2. We can use these values to verfiy someones signature using ecrecover


### How signing works
1. Get the signed message
   1. Break into v,r,s
2. Get the data itself
3. Use it as input parameters for `ecrrecover`