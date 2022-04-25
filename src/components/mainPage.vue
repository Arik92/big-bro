<template>
  <div class="container">
    <div class="manual-input">
      <label for="file">Upload data file</label>
      <input type="file" ref="file" accept="application/json" @change="onJsonUpload()">
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
            <td v-for="attribute in soldier" :key="attribute">{{attribute}}</td>            
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
</style>
<script>
// import axios from "axios";

export default {
  name: 'MainPage',  
  data() {
    return {
      title: "Soldier details",
      jsonData: [],
      tableHeaders: []        
    }
  },
  methods: {    
    readFile(file) {
     let reader = new FileReader();
     reader.onload = e => {
       let json = JSON.parse(e.target.result);
       console.log("parsed json ", json);       
        this.jsonData = json.soldierData;
        this.tableHeaders = Object.keys(json.soldierData[0]);
     }
     reader.readAsText(file);
   },
    onJsonUpload() {
      const jsonInput = this.$refs.file.files[0];
      this.readFile(jsonInput);
    }
  }
  // ,
  // mounted() {
  //   axios
  //     .get('http://127.0.0.1:8000/api/people')
  //     .then(response => this.jsonData = response.data.results)
  //     .catch(error => alert('Error fetching people data', error))
  // }
}
</script>
