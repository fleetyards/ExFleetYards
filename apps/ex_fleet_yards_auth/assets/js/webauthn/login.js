'use strict';

import {errorMessage, fromBase64, getCsrfToken, isWebAuthnSupported, toBase64} from "./helper";
import {WEBAUTHN_LOGIN_CHALLENGE_URL, WEBAUTHN_LOGIN_VALIDATE_URL} from "../vars";

function setMsg(msg) {
    document.getElementById('webauthn-msg-text').innerText = msg
    document.getElementById('webauthn-retry-btn').classList.remove('hidden')
}

function webAuthnLogin() {
    if (!isWebAuthnSupported()) {
        setMsg("This browser does not support WebAuthN")
        return
    }
    fetch(WEBAUTHN_LOGIN_CHALLENGE_URL, {
        method: 'POST',
        credentials: 'same-origin',
        headers: {
            "Content-Type": "application/json",
            "X-csrf-token": getCsrfToken(),
        }
    }).then(res => {
        if (res.status != 200) {
            setMsg("Failed to communicate with serer. Please try again later.")
            throw new Error("Oops")
        }
        return res;
    }).then(res => res.json())
        .then(response => {
            const challenge = response
            challenge.publicKey.challenge = fromBase64(challenge.publicKey.challenge)
            challenge.publicKey.allowCredentials = challenge.publicKey.allowCredentials.map(c => {
                c.id = fromBase64(c.id)
                return c
            });
            return navigator.credentials.get(challenge)
                .then(credentials => {
                    const pk = {};
                    pk.id = credentials.id;
                    pk.rawId = toBase64(credentials.rawId)
                    pk.response = {};
                    pk.response.authenticatorData = toBase64(credentials.response.authenticatorData);
                    pk.response.clientDataJSON = toBase64(credentials.response.clientDataJSON);
                    pk.response.signature = toBase64(credentials.response.signature);
                    pk.response.userHandle = toBase64(credentials.response.userHandle);
                    pk.type = credentials.type;

                    return fetch(WEBAUTHN_LOGIN_VALIDATE_URL, {
                        method: 'POST',
                        body: JSON.stringify(pk),
                        credentials: 'same-origin',
                        headers: {
                            "Content-Type": "application/json",
                            "X-csrf-token": getCsrfToken()
                        }
                    })
                        .then(res => {
                            if (res.status != 200) {
                                setMsg("Failed to authenticate.")
                            }
                            return res.text()
                        })
                        .then(res => {
                            window.location.replace(res)
                        })
                })
                .catch(e => {
                    setMsg(errorMessage(e))
                    console.log(e)
                })
        })
}

window.addEventListener('load', webAuthnLogin)
document.getElementById('webauthn-retry-btn').addEventListener('click', webAuthnLogin)