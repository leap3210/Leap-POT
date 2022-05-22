const serverUrl = ""; //Server url from moralis.io
const appId = ""; // Application id from moralis.io
Moralis.start({ serverUrl, appId });

const authButton = document.getElementById('btn-auth');

let user;
let web3;
let result = '';

const provider = 'walletconnect';

function renderApp() {
    user = Moralis.User.current();

    if (user) {
        authButton.innerText = 'Connected';

    } else {
        authButton.style.display = 'inline-block';

    }


}

async function authenticate() {
    try {
        user = await Moralis.authenticate({ provider });
        web3 = await Moralis.enableWeb3({ provider });
    } catch (error) {
        console.log('authenticate failed', error);
    }
    renderApp();
}

authButton.onclick = authenticate;

renderApp();


