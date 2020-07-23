function navigate(page)
{
    let wrapper = document.getElementById('wrapper');

    for(let i=0; i<wrapper.classList.length; i++)
    {
        if(wrapper.classList[i].indexOf('nav-') === 0)
        {
            wrapper.classList.remove(wrapper.classList[i]);
        }
    }

    if(page === 'home')
    {
        wrapper.classList.add('nav-home');
    }
    else if(page === 'stats')
    {
        wrapper.classList.add('nav-stats');
    }
    else if(page === 'about')
    {
        wrapper.classList.add('nav-about');
    }
    else if(page === 'faq')
    {
        wrapper.classList.add('nav-faq');
    }
    else if(page === 'results')
    {
        wrapper.classList.add('nav-results');
    }
    else if(page === 'submit')
    {
        wrapper.classList.add('nav-submit');
    }
    else
    {
        console.error('Page name "' + page + '" not found!');
    }
}
function updateFileName(fileInput)
{
    let displayField = document.getElementById('fileName');
    let fname = fileInput.value;

    if(fname === '')
    {
        displayField.value = 'No file selected.';
        return;
    }

    //remove "C:\fakepath\"
    fname = fname.split('\\');
    fname = fname[fname.length-1];

    displayField.value = fname;
}
function submitFile()
{
    showLoadingGif();
    let file = document.getElementById('file').files[0];
    let formData = new FormData();
    formData.append('fileData', file);
    fetch('request/processfile', {method:'POST', body:formData})
        .then(response => response.json())
        .then(data =>
        {
            console.log(data); //TODO
            hideLoadingGif();
            renderResults(data);
        });
}
function showLoadingGif()
{
    document.getElementsByClassName('spinner')[0].style.display = 'initial';
    document.getElementsByClassName('file-uploader')[0].style.display = 'none';
}
function hideLoadingGif()
{
    document.getElementsByClassName('spinner')[0].style.display = 'none';
    document.getElementsByClassName('file-uploader')[0].style.display = 'block';
}
function renderResults(data)
{
    //TODO: null case
    let container = document.getElementById('contentResults');
    container.innerHTML = '';
    for(charname in data)
    {
        let rowEl = document.createElement('div');
        rowEl.setAttribute('class', 'char-data');

        let nameEl = document.createElement('div');
        nameEl.setAttribute('class', 'char-data-info');
        nameEl.innerHTML = 'Character: ' + charname;

        let deathsEl = document.createElement('div');
        nameEl.setAttribute('class', 'char-data-info');
        nameEl.innerHTML = 'Total deaths: ' + data[charname];

        let buttonEl = document.createElement('button');
        buttonEl.setAttribute('onclick', 'renderSubmit("' + charname + '", ' + data[charname] + ')');
        button.setAttribute('class', 'char-data-button');
        buttonEl.innerHTML = 'Stats for this character';

        rowEl.appendChild(nameEl);
        rowEl.appendChild(deathsEl);
        rowEl.appendChild(buttonEl);

        container.appendChild(rowEl);
    }

    navigate('results');
}
function renderSubmit(charname, deaths)
{
    console.log(charname + deaths); //TODO:DEBUG
    document.getElementById('spanCharName').innerHTML = charname;
    document.getElementById('spanCharDeaths').innerHTML = deaths;

    navigate('submit');
}
function submitCharData(form)
{
    console.log('submitCharData'); //TODO:DEBUG
    //TODO:send data to DB
    //TODO:only navigate to stats page after server responds?
    //TODO:render user data in stats page along side aggregate results

    navigate('stats');
}