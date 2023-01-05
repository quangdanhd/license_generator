const read = require("read-file");
const CryptoJS = require("crypto-js");

licenseGenerator().then();

async function licenseGenerator() {
  const variables = getVariables();
  // check project
  if (typeof variables["project"] == "undefined") {
    return;
  }
  // check type
  if (typeof variables["type"] == "undefined") {
    return;
  }
  await getEnv().then(
    function (env) {
      if (typeof env["LICENSE_PRIVATE_KEY"] == "undefined") {
        console.log("Private key not found.");
        return;
      }
      if (typeof env["LICENSE_LIFETIME"] == "undefined") {
        console.log("License lifetime not found.");
        return;
      }
      // env variables
      const privateKey = env["LICENSE_PRIVATE_KEY"];
      const lifetime = env["LICENSE_LIFETIME"];
      // expires time
      let exp = getExpiresTime(variables["type"], lifetime);
      // license key
      const licenseKey = generatingLicenseKey();
      // expires time encrypt
      exp = encrypt(exp, privateKey);
      console.log({
        code: licenseKey,
        exp: exp,
      });
    },
    function (error) {
      console.log(error.message);
    }
  );
  // // project
  // const project = variables["project"];
}

function getVariables() {
  let variables = {};
  // argv
  const argv = process.argv.slice(2);
  argv.forEach(function (val) {
    const arr = val.split("=");
    if (arr.length !== 2) {
      return;
    }
    variables[arr[0].replace("--", "")] = arr[1];
  });
  return variables;
}

async function getEnv() {
  return new Promise((resolve, reject) => {
    read(".env", "utf8", function (err, text) {
      // check err
      if (err) {
        reject(Error("File .env not found."));
        return;
      }
      // get variables from env file
      const envArr = text.split("\n").filter((x) => !!x);
      let envObj = {};
      envArr.forEach((item) => {
        const arr = item.match(/(^[^=]+)=(.*$)/);
        if (arr.length !== 3) {
          return;
        }
        envObj[arr[1]] = arr[2];
      });
      resolve(envObj);
    });
  });
}
function getExpiresTime(type, lifetime) {
  let exp = null;
  const now = new Date(new Date().toUTCString());
  // type
  switch (type) {
    case "one-week":
      exp = now.setDate(now.getDate() * 7);
      break;
    case "one-month":
      exp = new Date(now.setMonth(now.getMonth() + 1)).getTime();
      break;
    case "six-months":
      exp = new Date(now.setMonth(now.getMonth() + 6)).getTime();
      break;
    case "one-year":
      exp = new Date(now.setFullYear(now.getFullYear() + 1)).getTime();
      break;
    case "lifetime":
      exp = lifetime;
      break;
    default:
      break;
  }
  return exp;
}

function encrypt(str, key) {
  return CryptoJS.AES.encrypt(str.toString(), key).toString();
}

function decrypt(str, key) {
  return CryptoJS.AES.decrypt(str.toString(), key.toString()).toString(
    CryptoJS.enc.Utf8
  );
}

function generatingLicenseKey() {
  let license = [];
  for (let i = 0; i < 5; i++) {
    license.push(makeId(6));
  }
  return license.join("-");
}

function makeId(length) {
  let result = "";
  const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  const charactersLength = characters.length;
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
}