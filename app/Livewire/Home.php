<?php

namespace App\Livewire;

use Livewire\Component;

#[Layout('components.layout.default')]
class Home extends Component
{
    public function render()
    {
        return view('livewire.home');
    }
}
