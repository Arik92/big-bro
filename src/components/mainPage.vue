<template>
  <div class="container">
    <!-- <div class="manual-input">
      <label for="file">Upload data file</label>
      <input
        type="file"
        ref="file"
        accept="application/json"
        @change="onJsonUpload()"
      />
    </div> -->
    <div class="manual-input">
      <label v-show="!csvFlags[0]" for="csv1">Upload sol CSV file</label>
      <input
        v-show="!csvFlags[0]"
        type="file"
        ref="csv1"
        accept=".csv"
        @change="onCsvUpload1"
      />
      <label v-show="!csvFlags[1]" for="csv2">Upload vol CSV file</label>
      <input
        v-show="!csvFlags[1]"
        type="file"
        ref="csv2"
        accept=".csv"
        @change="onCsvUpload2"
      />
    </div>

    <div class="title" v-text="title"></div>
    <table class="people-display">
      <thead>
        <tr>
          <th v-for="header in tableHeaders" :key="header" v-text="header"></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="soldier in jsonData" :key="soldier">
          <td v-for="attribute in soldier" :key="attribute">
            <span v-if="attribute=='True'" class="icon check"> ✓ 
              </span>
              <span v-else-if="attribute=='False'" class="icon ex"> X
              </span>
              <span v-else>
              {{ attribute }}
              </span>
            </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<style scoped>
.title {
  height: 10%;
  width: 100%;
  display: Flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}
.container {
  height: 100%;
  width: 100%;
  background-color: #c6aaaa;
  opacity: 0.8;
}
.people-display {
  height: 90%;
  width: 100%;
}
.icon {
  font-size: 30px;
}
.check {
    color: green;
}
.ex {
    color: red;
}
</style>
<script>
import axios from "axios";
axios.defaults.xsrfHeaderName = "X-CSRFTOKEN"
axios.defaults.xsrfCookieName = "csrftoken"
// axios.defaults.withCredentials = true

export default {
  name: "MainPage",
  data() {
    return {
      title: "Soldier details",
      jsonData: [],
      tableHeaders: [],
      csvFlags: [false, false],
      csvFiles: {
        sol: {},
        vol: {}
      },
    };
  },
  methods: {
    readJsonFile(file) {
      let reader = new FileReader();
      reader.onload = (e) => {
        let json = JSON.parse(e.target.result);
        this.jsonData = json.soldierData;
        this.tableHeaders = Object.keys(json.soldierData[0]);
      };
      reader.readAsText(file);
    },   
    csvToJson(csvText) {
      const lines = csvText.split("\n"); // 1️⃣line end
      const header = lines[0].split(","); // 2️⃣seperator
      const output = lines.slice(1).map((line) => {
        const fields = line.split(","); // 3️⃣
        return Object.fromEntries(header.map((h, i) => [h, fields[i]])); // 4️⃣
      });
      return output;
    },
    onCsvUpload1(e) {
     const file = e.target.files[0];
            const reader = new FileReader();
            reader.onload = e =>{
               console.log(e.target.result);
               this.csvFiles.sol = this.csvToJson(e.target.result);
               this.csvFlags[0] = true;
               this.sendCsvFiles();
            }
            reader.readAsText(file,"ISO-8859-8");      
    },
    onCsvUpload2(e) {
     const file = e.target.files[0];
            const reader = new FileReader();
            reader.onload = e =>{
               console.log(e.target.result);
               this.csvFiles.vol = this.csvToJson(e.target.result);
               this.csvFlags[1] = true;
               this.sendCsvFiles();
            }
            reader.readAsText(file,"ISO-8859-8");      
    },
    sendCsvFiles() {
      if (!this.csvFlags[0] || !this.csvFlags[1]) return;
      try {
        const requestData = JSON.stringify(this.csvFiles);
                // axios.post('http://localhost:8000/api/people', requestData).then(response => {

        axios.post('https://web-production-b413.up.railway.app/api/people', requestData).then(response => {
          const resDataObj = JSON.parse(response.data.results.soldiersMatch);
          this.jsonData = resDataObj;
          this.tableHeaders = Object.keys(resDataObj[0]);
          console.log('parsed json obj ', resDataObj);
          console.log("json data? ", this.jsonData);
          console.log('table headers ', this.tableHeaders);
      }).catch(err => {
        console.log('promise rejection err ', err);
      })
      }
      catch(error) {
        console.log("POST error ", error);
      }      
    },
    onJsonUpload() {
      const jsonInput = this.$refs.file.files[0];
      this.readJsonFile(jsonInput);
    }    
  }
};
</script>
