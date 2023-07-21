'use strict';

export function isWebAuthnSupported() {
    return window.PublicKeyCredential !== undefined && typeof window.PublicKeyCredential === "function"
}

export function getCsrfToken() {
    return document.head.querySelector('meta[name="csrf-token"]').content
}


export function toBase64(data) {
    return btoa(String.fromCharCode.apply(null, new Uint8Array(data)));
}

export function fromBase64(data) {
    return toArray(atob(data))
}

export function toArray(str) {
    return Uint8Array.from(str, c => c.charCodeAt(0));
}
