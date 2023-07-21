'use strict';

//import './u2f_helper.js'
import {
    isWebAuthnSupported,
    getCsrfToken,
    toBase64,
    fromBase64,
} from "./u2f_helper";
import {
    WEBAUTHN_REGISTER_VALIDATE_URL,
    WEBAUTHN_REGISTER_CHALLENGE_URL
} from "./vars.js";

function getLabel() {
    return document.getElementById('u2f_token_name').value
}

function webAuthnRegister() {
    if (!isWebAuthnSupported()) {
        alert("Sorry, Webauthn is not supported by your browser")
        return
    }

    const label = getLabel();
    if (label == "") {
        alert("No label given") // TODO: replace with inline error message
        return
    }

    fetch(WEBAUTHN_REGISTER_CHALLENGE_URL, {
        method: 'POST',
        credentials: 'same-origin',
        body: JSON.stringify({
            "label": label,
        }),
        headers: {
            "Content-Type": "application/json",
            "X-csrf-token": getCsrfToken()
        }
    })
        .then(res => res.json())
        .then(response => {
            const challenge = response;
            challenge.publicKey.challenge = fromBase64(challenge.publicKey.challenge);
            console.log(toBase64(challenge.publicKey.challenge))
            challenge.publicKey.user.id = fromBase64(challenge.publicKey.user.id);
            return navigator.credentials.create(challenge).then(newCredential => {
                const cc = {};
                cc.id = newCredential.id;
                cc.rawId = toBase64(newCredential.rawId);
                cc.response = {};
                cc.response.attestationObject = toBase64(newCredential.response.attestationObject);
                cc.response.clientDataJSON = toBase64(newCredential.response.clientDataJSON);
                cc.type = newCredential.type;
                cc.name = getLabel();
                fetch(WEBAUTHN_REGISTER_VALIDATE_URL, {
                    method: 'POST',
                    credentials: 'same-origin',
                    body: JSON.stringify(cc),
                    headers: {
                        "Content-Type": "application/json",
                        "X-csrf-token": getCsrfToken()
                    },
                }).then(res => {
                    if (res.status != 201) {
                        alert("There is an internal error. Try again later.") // replace with inline error message
                        throw new Error("Oopps");
                    }
                    document.location.reload(); // TODO: replace with live view?
                })
            })
        })
}

document.getElementById("u2fRegisterButton").addEventListener('click', webAuthnRegister)