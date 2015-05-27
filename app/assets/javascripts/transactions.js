$(document).ready(pageReady);
$(document).ready(function () {
	$('#created-daily-btn').click(function() {
		showDailyCreated();
		showWeeklyCreatedGraph();
	});
	$('#created-weekly-btn').click(function() {
		showWeeklyCreated();
		showWeeklyCreatedGraph();
	});
	$('#created-monthly-btn').click(function() {
		showMonthlyCreated();
		showMonthlyCreatedGraph();
	});
	$('#used-daily-btn').click(function(){
		showDailyUsed();
		showWeeklyUsedGraph();
	});
	$('#used-weekly-btn').click(function(){
		showWeeklyUsed();
		showWeeklyUsedGraph();
	});
	$('#used-monthly-btn').click(function(){
		showMonthlyUsed();
		showMonthlyUsedGraph();
	});
});



function pageReady() {
	$('.Weekly-Created, .Monthly-Created, .Weekly-Used, .Monthly-Used, #monthly-created-graph, #monthly-used-graph').hide();	
}

function showDailyCreated() {
	$('.Daily-Created').show();
	$('.Weekly-Created').hide();
	$('.Monthly-Created').hide();
}

function showWeeklyCreated() {
	$('.Daily-Created').hide();
	$('.Weekly-Created').show();
	$('.Monthly-Created').hide();
}

function showWeeklyCreatedGraph() {
	$('#monthly-created-graph').hide();
	$('#weekly-created-graph').show();
}

function showMonthlyCreated() {
	$('.Daily-Created').hide();
	$('.Weekly-Created').hide();
	$('.Monthly-Created').show();
}

function showMonthlyCreatedGraph() {
	$('#monthly-created-graph').show();
	$('#weekly-created-graph').hide();
}

function showDailyUsed() {
	$('.Daily-Used').show();
	$('.Weekly-Used').hide();
	$('.Monthly-Used').hide();
}

function showWeeklyUsed() {
	$('.Daily-Used').hide();
	$('.Weekly-Used').show();
	$('.Monthly-Used').hide();
}

function showWeeklyUsedGraph() {
	$('#monthly-used-graph').hide();
	$('#weekly-used-graph').show();
}

function showMonthlyUsed() {
	$('.Daily-Used').hide();
	$('.Weekly-Used').hide();
	$('.Monthly-Used').show();
}

function showMonthlyUsedGraph() {
	$('#monthly-used-graph').show();
	$('#weekly-used-graph').hide();
}