package ISUCON8::Portal::Web::Controller::API;
use strict;
use warnings;
use feature 'state';
use JSON;

sub enqueue_job {
    my ($self, $c) = @_;
    my $team_id = $c->team_id;

    my ($is_success, $err) = $c->model('Bench')->enqueue_job({ team_id => $team_id });

    if ($is_success) {
        return $c->render_json({ success => JSON::true });
    }
    else {
        return $c->render_json({ success => JSON::false, error => $err });
    }
}

sub cancel_job {
    my ($self, $c) = @_;
    my $team_id = $c->team_id;

    # TODO
    $c->res_404;
}

sub change_target {
    my ($self, $c) = @_;
    state $rule = $c->make_validator(
        global_ip => { isa => 'Str' },
    );

    my $params = $c->validate($rule, $c->req->body_parameters->mixed);
    unless ($params) {
        $c->log->warnf('validate error: %s', $rule->error->{message});
        return $c->res_400;
    }

    my $team_id = $c->team_id;
    my $model   = $c->model('Team');
    my ($is_success, $err) = $model->change_benchmark_target({
        team_id   => $team_id,
        global_ip => $params->{global_ip},
    });

    if ($is_success) {
        return $c->render_json({ success => JSON::true });
    }
    else {
        return $c->render_json({ success => JSON::false, error => $err });
    }
}

1;
