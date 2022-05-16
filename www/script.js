var helpTimeout = null;
Shiny.addCustomMessageHandler("startHelp", function(data){
  (document.getElementsByTagName("body")[0]).style.overflow = "hidden";

  window.scrollTo(0, 0);

  var introSteps = introJs();
  content=data.steps;

  for(i=0;i<content.length;i++)
  {
    text=content[i]["intro"];
    textarr=text.split("|");
    textarr[0]="</div><span class='help-header'>"+textarr[0]+"</span><div class ='introjs-div-help-number'><span class='help-number'>"+(i+1)+"</span><span class = 'introjs-help-number-oblique'>/</span><span class='help-number2'>"+content.length+"</span></div></div>";
    textarr[1]="<p class='help-text'>"+textarr[1]+"</p>";
    content[i]["intro"]=textarr.join(" ");
  }

  introSteps.setOptions({steps: content,nextLabel:'Next',prevLabel:'Prev',showBullets:false});

  introSteps.onbeforechange(function(targetElement) {
  clearTimeout(helpTimeout);
  if(introSteps._currentStep != content.length-1)
    helpTimeout = setTimeout(function(){  introSteps.nextStep()}, 5000);
  else
    helpTimeout = setTimeout(function(){  introSteps.exit()}, 5000);
  if(targetElement.querySelector(".loader-gif")!==null)
    targetElement.querySelector(".loader-gif").style.visibility="hidden";
  })

  introSteps.onexit(function() {
    clearTimeout(helpTimeout);
    window.scrollTo(0, 0);
    (document.getElementsByTagName("body")[0]).style.overflow = "auto";
  })

  introSteps.start();
}
);
