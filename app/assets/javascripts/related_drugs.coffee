$ ->
  $("#related_drugs").load("/drugs/" + $("#drug_name").text().trim() + "/related")

